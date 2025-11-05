export interface Profile {
  id: string
  email: string
  created_at: string
}

export interface Project {
  id: string
  user_id: string
  title: string
  type: 'Roman' | 'Nouvelle' | 'Novella'
  genre?: string
  pitch?: string
  act1_dramatic_function?: string
  act1_narrative_goal?: string
  act1_turning_point?: string
  act2_dramatic_function?: string
  act2_narrative_goal?: string
  act2_turning_point?: string
  act2_midpoint?: string
  act3_dramatic_function?: string
  act3_narrative_goal?: string
  act3_turning_point?: string
  act3_climax?: string
  created_at: string
  updated_at: string
}

export interface StudioChapter {
  id: string
  project_id: string
  title: string
  synopsis?: string
  order_index: number
  created_at: string
  updated_at: string
}

export interface StudioScene {
  id: string
  chapter_id: string
  title: string
  content: string
  synopsis?: string
  word_count: number
  status?: 'Idée' | 'En cours' | 'Terminé'
  act: 1 | 2 | 3
  location_id?: string
  plot_point_id?: string
  order_index: number
  created_at: string
  updated_at: string
}

export interface Character {
  id: string
  project_id: string
  name: string
  role?: string
  description?: string
  first_name?: string
  last_name?: string
  age?: number
  gender?: string
  origin?: string
  appearance?: string
  distinctive_signs?: string
  dressing_style?: string
  walking_style?: string
  speaking_style?: string
  dominant_traits?: string
  values_and_beliefs?: string
  deep_fears?: string
  original_wound?: string
  obstacles?: string
  transformation_arc?: string
  archetype?: string
  thematic_representation?: string
  motivations?: string
  history?: string
  psychology?: string
  internal_goal?: string
  external_goal?: string
  past_relationships?: string
  founding_event?: string
  education_and_background?: string
  family_origins?: string
  tics_and_humor?: string
  inner_need?: string
  associated_memories?: string
  key_quote?: string
  behavior_under_pressure?: string
  sensory_details?: string
  worldview_contribution?: string
  dynamics_with_others?: string
  created_at: string
  updated_at: string
}

export interface Location {
  id: string
  project_id: string
  name: string
  location_type?: string
  localization?: string
  time_period?: string
  architecture?: string
  notable_elements?: string
  dominant_atmosphere?: string
  main_smells?: string
  characteristic_sounds?: string
  textures?: string
  lighting?: string
  dominant_color?: string
  narrative_role?: string
  key_events?: string
  dramatic_tension?: string
  location_evolution?: string
  symbolic_meaning?: string
  emotional_link?: string
  key_objects?: string
  visual_references?: string
  symbolic_quote?: string
  created_at: string
  updated_at: string
}

export interface PlotPoint {
  id: string
  project_id: string
  title: string
  type: 'Point-clé' | 'Incident déclencheur' | 'Point tournant' | 'Point médian' | 'Climax' | 'Résolution' | 'Obstacle' | 'Révélation' | 'Autre'
  act: 1 | 2 | 3
  description?: string
  order_index: number
  created_at: string
  updated_at: string
}

export interface StudioSceneCharacter {
  id: string
  scene_id: string
  character_id: string
  created_at: string
}

export interface StudioAnnotation {
  id: string
  scene_id: string
  comment: string
  text_content: string
  position_start: number
  position_end: number
  created_at: string
}
