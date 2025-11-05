-- Pulse Noir Studio - Complete Database Schema
-- This file should be executed in Supabase SQL Editor

-- ================================================
-- 1. PROFILES TABLE
-- ================================================
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================
-- 2. PROJECTS TABLE
-- ================================================
CREATE TABLE IF NOT EXISTS projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('Roman', 'Nouvelle', 'Novella')),
  genre TEXT,
  pitch TEXT,
  act1_dramatic_function TEXT,
  act1_narrative_goal TEXT,
  act1_turning_point TEXT,
  act2_dramatic_function TEXT,
  act2_narrative_goal TEXT,
  act2_turning_point TEXT,
  act2_midpoint TEXT,
  act3_dramatic_function TEXT,
  act3_narrative_goal TEXT,
  act3_turning_point TEXT,
  act3_climax TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================
-- 3. STUDIO CHAPTERS TABLE
-- ================================================
CREATE TABLE IF NOT EXISTS studio_chapters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  synopsis TEXT,
  order_index INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================
-- 4. CHARACTERS TABLE
-- ================================================
CREATE TABLE IF NOT EXISTS characters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  role TEXT,
  description TEXT,
  first_name TEXT,
  last_name TEXT,
  age INTEGER,
  gender TEXT,
  origin TEXT,
  appearance TEXT,
  distinctive_signs TEXT,
  dressing_style TEXT,
  walking_style TEXT,
  speaking_style TEXT,
  dominant_traits TEXT,
  values_and_beliefs TEXT,
  deep_fears TEXT,
  original_wound TEXT,
  obstacles TEXT,
  transformation_arc TEXT,
  archetype TEXT,
  thematic_representation TEXT,
  motivations TEXT,
  history TEXT,
  psychology TEXT,
  internal_goal TEXT,
  external_goal TEXT,
  past_relationships TEXT,
  founding_event TEXT,
  education_and_background TEXT,
  family_origins TEXT,
  tics_and_humor TEXT,
  inner_need TEXT,
  associated_memories TEXT,
  key_quote TEXT,
  behavior_under_pressure TEXT,
  sensory_details TEXT,
  worldview_contribution TEXT,
  dynamics_with_others TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================
-- 5. LOCATIONS TABLE
-- ================================================
CREATE TABLE IF NOT EXISTS locations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  location_type TEXT,
  localization TEXT,
  time_period TEXT,
  architecture TEXT,
  notable_elements TEXT,
  dominant_atmosphere TEXT,
  main_smells TEXT,
  characteristic_sounds TEXT,
  textures TEXT,
  lighting TEXT,
  dominant_color TEXT,
  narrative_role TEXT,
  key_events TEXT,
  dramatic_tension TEXT,
  location_evolution TEXT,
  symbolic_meaning TEXT,
  emotional_link TEXT,
  key_objects TEXT,
  visual_references TEXT,
  symbolic_quote TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================
-- 6. PLOT POINTS TABLE
-- ================================================
CREATE TABLE IF NOT EXISTS plot_points (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('Point-clé', 'Incident déclencheur', 'Point tournant', 'Point médian', 'Climax', 'Résolution', 'Obstacle', 'Révélation', 'Autre')),
  act INTEGER NOT NULL CHECK (act IN (1, 2, 3)),
  description TEXT,
  order_index INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================
-- 7. STUDIO SCENES TABLE (after plot_points and locations)
-- ================================================
CREATE TABLE IF NOT EXISTS studio_scenes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  chapter_id UUID REFERENCES studio_chapters(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  content TEXT DEFAULT '',
  synopsis TEXT,
  word_count INTEGER DEFAULT 0,
  status TEXT CHECK (status IN ('Idée', 'En cours', 'Terminé')),
  act INTEGER NOT NULL CHECK (act IN (1, 2, 3)),
  location_id UUID REFERENCES locations(id) ON DELETE SET NULL,
  plot_point_id UUID REFERENCES plot_points(id) ON DELETE SET NULL,
  order_index INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================
-- 8. STUDIO SCENE CHARACTERS (junction table)
-- ================================================
CREATE TABLE IF NOT EXISTS studio_scene_characters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scene_id UUID REFERENCES studio_scenes(id) ON DELETE CASCADE NOT NULL,
  character_id UUID REFERENCES characters(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(scene_id, character_id)
);

-- ================================================
-- 9. STUDIO ANNOTATIONS TABLE
-- ================================================
CREATE TABLE IF NOT EXISTS studio_annotations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scene_id UUID REFERENCES studio_scenes(id) ON DELETE CASCADE NOT NULL,
  comment TEXT NOT NULL,
  text_content TEXT NOT NULL,
  position_start INTEGER NOT NULL,
  position_end INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ================================================
-- FUNCTIONS
-- ================================================

-- Function to update scene characters
CREATE OR REPLACE FUNCTION update_studio_scene_characters(p_scene_id UUID, p_character_ids UUID[])
RETURNS VOID AS $$
BEGIN
  DELETE FROM studio_scene_characters WHERE scene_id = p_scene_id;
  IF array_length(p_character_ids, 1) > 0 THEN
    INSERT INTO studio_scene_characters (scene_id, character_id)
    SELECT p_scene_id, unnest(p_character_ids);
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to automatically create profile on user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email)
  VALUES (new.id, new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ================================================
-- TRIGGERS
-- ================================================

-- Trigger for new user profile creation
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Triggers for updated_at
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_studio_chapters_updated_at BEFORE UPDATE ON studio_chapters
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_studio_scenes_updated_at BEFORE UPDATE ON studio_scenes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_characters_updated_at BEFORE UPDATE ON characters
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_locations_updated_at BEFORE UPDATE ON locations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_plot_points_updated_at BEFORE UPDATE ON plot_points
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================================
-- ROW LEVEL SECURITY (RLS)
-- ================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_chapters ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_scenes ENABLE ROW LEVEL SECURITY;
ALTER TABLE characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE plot_points ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_scene_characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE studio_annotations ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Users can view their own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Projects policies
CREATE POLICY "Users can view their own projects"
  ON projects FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own projects"
  ON projects FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own projects"
  ON projects FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own projects"
  ON projects FOR DELETE
  USING (auth.uid() = user_id);

-- Studio chapters policies
CREATE POLICY "Users can view chapters of their projects"
  ON studio_chapters FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = studio_chapters.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can insert chapters in their projects"
  ON studio_chapters FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = studio_chapters.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can update chapters in their projects"
  ON studio_chapters FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = studio_chapters.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can delete chapters in their projects"
  ON studio_chapters FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = studio_chapters.project_id
    AND projects.user_id = auth.uid()
  ));

-- Studio scenes policies
CREATE POLICY "Users can view scenes of their projects"
  ON studio_scenes FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM studio_chapters
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_chapters.id = studio_scenes.chapter_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can insert scenes in their projects"
  ON studio_scenes FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM studio_chapters
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_chapters.id = studio_scenes.chapter_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can update scenes in their projects"
  ON studio_scenes FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM studio_chapters
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_chapters.id = studio_scenes.chapter_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can delete scenes in their projects"
  ON studio_scenes FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM studio_chapters
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_chapters.id = studio_scenes.chapter_id
    AND projects.user_id = auth.uid()
  ));

-- Characters policies
CREATE POLICY "Users can view characters of their projects"
  ON characters FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = characters.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can insert characters in their projects"
  ON characters FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = characters.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can update characters in their projects"
  ON characters FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = characters.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can delete characters in their projects"
  ON characters FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = characters.project_id
    AND projects.user_id = auth.uid()
  ));

-- Locations policies
CREATE POLICY "Users can view locations of their projects"
  ON locations FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = locations.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can insert locations in their projects"
  ON locations FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = locations.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can update locations in their projects"
  ON locations FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = locations.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can delete locations in their projects"
  ON locations FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = locations.project_id
    AND projects.user_id = auth.uid()
  ));

-- Plot points policies
CREATE POLICY "Users can view plot points of their projects"
  ON plot_points FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = plot_points.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can insert plot points in their projects"
  ON plot_points FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = plot_points.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can update plot points in their projects"
  ON plot_points FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = plot_points.project_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can delete plot points in their projects"
  ON plot_points FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = plot_points.project_id
    AND projects.user_id = auth.uid()
  ));

-- Studio scene characters policies
CREATE POLICY "Users can view scene characters of their projects"
  ON studio_scene_characters FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM studio_scenes
    JOIN studio_chapters ON studio_chapters.id = studio_scenes.chapter_id
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_scenes.id = studio_scene_characters.scene_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can insert scene characters in their projects"
  ON studio_scene_characters FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM studio_scenes
    JOIN studio_chapters ON studio_chapters.id = studio_scenes.chapter_id
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_scenes.id = studio_scene_characters.scene_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can delete scene characters in their projects"
  ON studio_scene_characters FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM studio_scenes
    JOIN studio_chapters ON studio_chapters.id = studio_scenes.chapter_id
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_scenes.id = studio_scene_characters.scene_id
    AND projects.user_id = auth.uid()
  ));

-- Studio annotations policies
CREATE POLICY "Users can view annotations of their projects"
  ON studio_annotations FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM studio_scenes
    JOIN studio_chapters ON studio_chapters.id = studio_scenes.chapter_id
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_scenes.id = studio_annotations.scene_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can insert annotations in their projects"
  ON studio_annotations FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM studio_scenes
    JOIN studio_chapters ON studio_chapters.id = studio_scenes.chapter_id
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_scenes.id = studio_annotations.scene_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can update annotations in their projects"
  ON studio_annotations FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM studio_scenes
    JOIN studio_chapters ON studio_chapters.id = studio_scenes.chapter_id
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_scenes.id = studio_annotations.scene_id
    AND projects.user_id = auth.uid()
  ));

CREATE POLICY "Users can delete annotations in their projects"
  ON studio_annotations FOR DELETE
  USING (EXISTS (
    SELECT 1 FROM studio_scenes
    JOIN studio_chapters ON studio_chapters.id = studio_scenes.chapter_id
    JOIN projects ON projects.id = studio_chapters.project_id
    WHERE studio_scenes.id = studio_annotations.scene_id
    AND projects.user_id = auth.uid()
  ));

-- ================================================
-- INDEXES for performance
-- ================================================
CREATE INDEX IF NOT EXISTS idx_projects_user_id ON projects(user_id);
CREATE INDEX IF NOT EXISTS idx_studio_chapters_project_id ON studio_chapters(project_id);
CREATE INDEX IF NOT EXISTS idx_studio_scenes_chapter_id ON studio_scenes(chapter_id);
CREATE INDEX IF NOT EXISTS idx_studio_scenes_location_id ON studio_scenes(location_id);
CREATE INDEX IF NOT EXISTS idx_studio_scenes_plot_point_id ON studio_scenes(plot_point_id);
CREATE INDEX IF NOT EXISTS idx_characters_project_id ON characters(project_id);
CREATE INDEX IF NOT EXISTS idx_locations_project_id ON locations(project_id);
CREATE INDEX IF NOT EXISTS idx_plot_points_project_id ON plot_points(project_id);
CREATE INDEX IF NOT EXISTS idx_studio_scene_characters_scene_id ON studio_scene_characters(scene_id);
CREATE INDEX IF NOT EXISTS idx_studio_scene_characters_character_id ON studio_scene_characters(character_id);
CREATE INDEX IF NOT EXISTS idx_studio_annotations_scene_id ON studio_annotations(scene_id);
