import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase, auth } from '@/lib/supabase'
import { useAuth } from '@/contexts/AuthContext'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle } from '@/components/ui/alert-dialog'
import { Plus, Trash2, Edit } from 'lucide-react'
import { toast } from 'sonner'
import type { Project } from '@/types/database.types'
import { formatDate } from '@/lib/utils'

export function DashboardPage() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const queryClient = useQueryClient()

  const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false)
  const [projectToDelete, setProjectToDelete] = useState<string | null>(null)

  const [newProject, setNewProject] = useState({
    title: '',
    type: 'Roman' as 'Roman' | 'Nouvelle' | 'Novella',
    genre: '',
    pitch: '',
  })

  // Fetch projects
  const { data: projects, isLoading } = useQuery({
    queryKey: ['projects', user?.id],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('projects')
        .select('*')
        .eq('user_id', user!.id)
        .order('created_at', { ascending: false })

      if (error) throw error
      return data as Project[]
    },
    enabled: !!user,
  })

  // Create project mutation
  const createMutation = useMutation({
    mutationFn: async (projectData: typeof newProject) => {
      const { data, error } = await supabase
        .from('projects')
        .insert({
          ...projectData,
          user_id: user!.id,
        })
        .select()
        .single()

      if (error) throw error
      return data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['projects'] })
      toast.success('Projet créé avec succès')
      setIsCreateDialogOpen(false)
      setNewProject({ title: '', type: 'Roman', genre: '', pitch: '' })
    },
    onError: (error: any) => {
      toast.error('Erreur lors de la création', {
        description: error.message,
      })
    },
  })

  // Delete project mutation
  const deleteMutation = useMutation({
    mutationFn: async (projectId: string) => {
      const { error } = await supabase
        .from('projects')
        .delete()
        .eq('id', projectId)

      if (error) throw error
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['projects'] })
      toast.success('Projet supprimé')
      setProjectToDelete(null)
    },
    onError: (error: any) => {
      toast.error('Erreur lors de la suppression', {
        description: error.message,
      })
    },
  })

  const handleSignOut = async () => {
    await auth.signOut()
    navigate('/')
  }

  const handleCreateProject = (e: React.FormEvent) => {
    e.preventDefault()
    createMutation.mutate(newProject)
  }

  return (
    <div className="min-h-screen bg-background">
      <header className="border-b border-border">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <img src="/logostudio.png" alt="Pulse Noir Studio" className="h-10" />
            <span className="text-xl font-bold">Pulse Noir, le Studio</span>
          </div>
          <div className="flex items-center gap-4">
            <span className="text-sm text-muted-foreground">{user?.email}</span>
            <Button variant="outline" onClick={handleSignOut}>
              Déconnexion
            </Button>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-4xl font-bold mb-2">Mes Projets</h1>
            <p className="text-muted-foreground">Gérez vos romans, nouvelles et novellas</p>
          </div>

          <Dialog open={isCreateDialogOpen} onOpenChange={setIsCreateDialogOpen}>
            <DialogTrigger asChild>
              <Button size="lg">
                <Plus className="mr-2 h-5 w-5" />
                Nouveau Projet
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>Créer un nouveau projet</DialogTitle>
                <DialogDescription>
                  Commencez votre nouvelle histoire
                </DialogDescription>
              </DialogHeader>
              <form onSubmit={handleCreateProject}>
                <div className="space-y-4 py-4">
                  <div className="space-y-2">
                    <Label htmlFor="title">Titre *</Label>
                    <Input
                      id="title"
                      value={newProject.title}
                      onChange={(e) => setNewProject({ ...newProject, title: e.target.value })}
                      required
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="type">Type *</Label>
                    <Select
                      value={newProject.type}
                      onValueChange={(value: any) => setNewProject({ ...newProject, type: value })}
                    >
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Roman">Roman</SelectItem>
                        <SelectItem value="Nouvelle">Nouvelle</SelectItem>
                        <SelectItem value="Novella">Novella</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="genre">Genre</Label>
                    <Input
                      id="genre"
                      placeholder="ex: Thriller, Fantasy, Romance..."
                      value={newProject.genre}
                      onChange={(e) => setNewProject({ ...newProject, genre: e.target.value })}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="pitch">Pitch</Label>
                    <Textarea
                      id="pitch"
                      placeholder="Résumé de votre histoire..."
                      rows={4}
                      value={newProject.pitch}
                      onChange={(e) => setNewProject({ ...newProject, pitch: e.target.value })}
                    />
                  </div>
                </div>
                <DialogFooter>
                  <Button type="button" variant="outline" onClick={() => setIsCreateDialogOpen(false)}>
                    Annuler
                  </Button>
                  <Button type="submit" disabled={createMutation.isPending}>
                    {createMutation.isPending ? 'Création...' : 'Créer'}
                  </Button>
                </DialogFooter>
              </form>
            </DialogContent>
          </Dialog>
        </div>

        {isLoading ? (
          <div className="text-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
            <p className="mt-4 text-muted-foreground">Chargement...</p>
          </div>
        ) : projects && projects.length > 0 ? (
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {projects.map((project) => (
              <Card key={project.id} className="hover:shadow-lg transition-shadow">
                <CardHeader>
                  <CardTitle>{project.title}</CardTitle>
                  <CardDescription>
                    {project.type} {project.genre && `• ${project.genre}`}
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  {project.pitch && (
                    <p className="text-sm text-muted-foreground line-clamp-3">
                      {project.pitch}
                    </p>
                  )}
                  <p className="text-xs text-muted-foreground mt-4">
                    Créé le {formatDate(project.created_at)}
                  </p>
                </CardContent>
                <CardFooter className="gap-2">
                  <Button
                    className="flex-1"
                    onClick={() => navigate(`/studio/${project.id}`)}
                  >
                    <Edit className="mr-2 h-4 w-4" />
                    Studio
                  </Button>
                  <Button
                    variant="destructive"
                    size="icon"
                    onClick={() => setProjectToDelete(project.id)}
                  >
                    <Trash2 className="h-4 w-4" />
                  </Button>
                </CardFooter>
              </Card>
            ))}
          </div>
        ) : (
          <Card className="text-center py-12">
            <CardContent className="pt-6">
              <p className="text-muted-foreground mb-4">
                Vous n'avez pas encore de projet
              </p>
              <Button onClick={() => setIsCreateDialogOpen(true)}>
                <Plus className="mr-2 h-5 w-5" />
                Créer votre premier projet
              </Button>
            </CardContent>
          </Card>
        )}
      </main>

      {/* Delete confirmation dialog */}
      <AlertDialog open={!!projectToDelete} onOpenChange={() => setProjectToDelete(null)}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Êtes-vous sûr ?</AlertDialogTitle>
            <AlertDialogDescription>
              Cette action est irréversible. Le projet et toutes ses données (chapitres, scènes, personnages, lieux) seront définitivement supprimés.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Annuler</AlertDialogCancel>
            <AlertDialogAction
              onClick={() => projectToDelete && deleteMutation.mutate(projectToDelete)}
              className="bg-destructive hover:bg-destructive/90"
            >
              Supprimer
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  )
}
