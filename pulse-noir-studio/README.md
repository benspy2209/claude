# Pulse Noir, le Studio

Environnement d'écriture professionnel complet pour romanciers et nouvellistes.

## 🚀 Stack Technique

- **Frontend**: React 18 + TypeScript + Vite
- **Backend**: Supabase (PostgreSQL + Authentication + Edge Functions)
- **UI**: Tailwind CSS + shadcn/ui + Radix UI
- **Éditeur**: TipTap (WYSIWYG)
- **Drag & Drop**: @dnd-kit
- **Routing**: React Router v6
- **State Management**: TanStack Query (React Query)
- **Thème**: Dark mode uniquement avec next-themes

## 📦 Installation

### Prérequis

- Node.js 18+ et npm
- Un compte Supabase (gratuit)

### Étapes

1. **Cloner le repository**
```bash
git clone <repo-url>
cd pulse-noir-studio
```

2. **Installer les dépendances**
```bash
npm install
```

3. **Configurer Supabase**

Créez un nouveau projet sur [Supabase](https://supabase.com)

4. **Créer le fichier .env**
```bash
cp .env.example .env
```

Remplissez les variables d'environnement :
```
VITE_SUPABASE_URL=votre_url_supabase
VITE_SUPABASE_ANON_KEY=votre_anon_key_supabase
```

5. **Initialiser la base de données**

Dans le SQL Editor de Supabase, exécutez le fichier `supabase-schema.sql` qui créera :
- Toutes les tables
- Les fonctions PostgreSQL
- Les triggers
- Les policies RLS

6. **Lancer l'application en développement**
```bash
npm run dev
```

L'application sera disponible sur `http://localhost:5173`

## 🗄️ Structure de la Base de Données

### Tables principales

- **profiles** - Profils utilisateurs
- **projects** - Projets (Romans, Nouvelles, Novellas)
- **studio_chapters** - Chapitres des projets
- **studio_scenes** - Scènes des chapitres
- **characters** - Personnages avec fiches détaillées
- **locations** - Lieux avec atmosphère et symbolique
- **plot_points** - Points d'intrigue par acte
- **studio_scene_characters** - Liaison scènes ↔ personnages
- **studio_annotations** - Annotations dans les scènes

## 🏗️ Architecture de l'Application

### Pages

- **/** - Landing page publique
- **/auth** - Connexion / Inscription
- **/dashboard** - Liste des projets (protégé)
- **/studio/:projectId** - Interface principale du studio (protégé)

### Vues du Studio

Le studio comprendra plusieurs vues :

1. **Manuscrit** - Éditeur TipTap avec chapitres et scènes
2. **Personnages** - Gestion des personnages avec fiches complètes
3. **Lieux** - Worldbuilding et gestion des lieux
4. **Synthèse** - Vue d'ensemble du projet et structure en 3 actes
5. **Structure** - Organisation des chapitres/scènes (modes Liste et Timeline)
6. **Intrigue** - Gestion des points d'intrigue par acte
7. **Statistiques** - Métriques du projet (mots, pages, etc.)

## 🎨 Fonctionnalités Clés

### Éditeur de Texte
- TipTap avec extensions personnalisées
- Auto-sauvegarde avec debounce (1s)
- Comptage de mots en temps réel
- Extension dialogue pour formatage automatique
- Annotations contextuelles

### Gestion de Projet
- CRUD complet pour projets, chapitres, scènes
- Fiches personnages détaillées (30+ champs)
- Fiches lieux avec atmosphère sensorielle
- Organisation par structure en 3 actes

### Drag & Drop
- Réorganisation des scènes dans les chapitres
- Liaison scènes ↔ points d'intrigue

### Recherche Globale
- Raccourci clavier: Ctrl+Shift+F (Cmd+Shift+F sur Mac)
- Recherche dans scènes, personnages, lieux, plot points

## 🔒 Sécurité

- Row Level Security (RLS) activé sur toutes les tables
- Authentification via Supabase Auth
- Routes protégées côté client
- Validation des données côté serveur

## 📝 Développement

### Scripts disponibles

```bash
npm run dev       # Lancer en mode développement
npm run build     # Build de production
npm run preview   # Prévisualiser le build
npm run lint      # Linter le code
```

### Structure des dossiers

```
src/
├── components/       # Composants réutilisables
│   ├── ui/          # Composants shadcn/ui
│   └── studio/      # Composants spécifiques au studio
├── contexts/        # Contextes React (Auth, etc.)
├── hooks/           # Custom hooks
├── lib/             # Utilitaires et configuration
├── pages/           # Pages de l'application
│   ├── landing/
│   ├── auth/
│   ├── dashboard/
│   └── studio/
└── types/           # Types TypeScript
```

## 🚧 État d'Avancement

### ✅ Complété

- [x] Configuration initiale du projet
- [x] Setup Tailwind CSS et shadcn/ui
- [x] Schéma complet de la base de données
- [x] Configuration Supabase
- [x] Système d'authentification
- [x] Landing page
- [x] Page d'authentification
- [x] Dashboard avec gestion des projets
- [x] Structure de base du Studio
- [x] React Router avec routes protégées
- [x] React Query pour la gestion d'état

### 🚧 En cours / À faire

- [ ] Studio - Layout triple colonnes avec sidebars
- [ ] Vue Manuscrit avec éditeur TipTap complet
- [ ] Extensions TipTap personnalisées (Dialogue, Annotations)
- [ ] Vue Personnages avec formulaire étendu
- [ ] Vue Lieux avec formulaire étendu
- [ ] Vue Synthèse (Overview) avec structure 3 actes
- [ ] Vue Structure (Liste + Timeline avec drag & drop)
- [ ] Vue Intrigue (Plot points)
- [ ] Vue Statistiques
- [ ] SceneSidepanel avec tabs et drag & drop
- [ ] Quick Views (personnages, lieux)
- [ ] Recherche globale (Ctrl+Shift+F)
- [ ] Edge Function pour import de structure narrative
- [ ] Tests et optimisations
- [ ] Responsive design complet

## 🎯 Prochaines Étapes

1. Implémenter le layout du Studio avec les trois colonnes
2. Créer l'éditeur TipTap avec toutes les extensions
3. Développer les vues CharactersView et LocationsView
4. Implémenter le système de drag & drop pour la structure
5. Ajouter la recherche globale
6. Optimiser les performances et la responsivité

## 📄 Licence

Tous droits réservés © 2025 Pulse Noir, le Studio

## 🤝 Contributing

Ce projet est en développement actif. Les contributions ne sont pas encore acceptées.

---

**Note**: Cette application est en cours de développement. Certaines fonctionnalités décrites peuvent ne pas être encore implémentées.
