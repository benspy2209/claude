import { useNavigate } from 'react-router-dom'
import { useAuth } from '@/contexts/AuthContext'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import {
  BookOpen, Users, MapPin, Layout, PenTool, Sparkles,
  Target, TrendingUp, CheckCircle2
} from 'lucide-react'
import { useEffect } from 'react'

export function LandingPage() {
  const navigate = useNavigate()
  const { user } = useAuth()

  useEffect(() => {
    if (user) {
      navigate('/dashboard')
    }
  }, [user, navigate])

  const features = [
    {
      icon: BookOpen,
      title: 'Manuscrit Intégré',
      description: 'Écrivez directement dans l\'éditeur avec auto-sauvegarde et comptage de mots'
    },
    {
      icon: Users,
      title: 'Fiches Personnages',
      description: 'Créez des personnages riches avec profondeur psychologique et arcs narratifs'
    },
    {
      icon: MapPin,
      title: 'Univers & Lieux',
      description: 'Construisez des lieux vivants avec atmosphère et signification symbolique'
    },
    {
      icon: Layout,
      title: 'Plan en 3 Actes',
      description: 'Structurez votre histoire selon la structure narrative classique'
    },
    {
      icon: PenTool,
      title: 'Outils d\'Écriture',
      description: 'Éditeur riche avec formatage, dialogues et annotations'
    },
    {
      icon: Sparkles,
      title: 'Synthèse Narrative',
      description: 'Vue d\'ensemble de votre projet et de sa progression'
    }
  ]

  const steps = [
    'Créez votre projet',
    'Structurez votre histoire',
    'Enrichissez votre univers',
    'Écrivez votre manuscrit'
  ]

  const benefits = [
    {
      icon: Target,
      title: 'Restez organisé',
      description: 'Tous vos éléments narratifs au même endroit'
    },
    {
      icon: TrendingUp,
      title: 'Gagnez en productivité',
      description: 'Auto-sauvegarde et outils d\'écriture optimisés'
    },
    {
      icon: Sparkles,
      title: 'Stimulez votre créativité',
      description: 'Outils de worldbuilding et développement de personnages'
    },
    {
      icon: CheckCircle2,
      title: 'Suivez votre progression',
      description: 'Statistiques en temps réel et organisation par actes'
    }
  ]

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b border-border">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <img src="/logostudio.png" alt="Pulse Noir Studio" className="h-10" />
            <span className="text-xl font-bold">Pulse Noir, le Studio</span>
          </div>
          <Button onClick={() => navigate('/auth')} size="lg">
            Commencer
          </Button>
        </div>
      </header>

      {/* Hero Section */}
      <section className="relative py-20 px-4 overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-b from-primary/10 to-background"></div>
        <div className="container mx-auto text-center relative z-10">
          <h1 className="text-5xl md:text-6xl font-bold mb-6">
            Donnez vie à vos histoires
          </h1>
          <p className="text-xl text-muted-foreground mb-8 max-w-2xl mx-auto">
            L'environnement d'écriture complet pour romanciers et nouvellistes
          </p>
          <Button onClick={() => navigate('/auth')} size="lg" className="text-lg px-8">
            Démarrer gratuitement
          </Button>
        </div>
      </section>

      {/* Features */}
      <section className="py-20 px-4 bg-muted/30">
        <div className="container mx-auto">
          <h2 className="text-3xl font-bold text-center mb-12">Fonctionnalités</h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {features.map((feature, index) => (
              <Card key={index}>
                <CardHeader>
                  <feature.icon className="h-10 w-10 text-primary mb-2" />
                  <CardTitle>{feature.title}</CardTitle>
                </CardHeader>
                <CardContent>
                  <CardDescription>{feature.description}</CardDescription>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* How it works */}
      <section className="py-20 px-4">
        <div className="container mx-auto">
          <h2 className="text-3xl font-bold text-center mb-12">Comment ça marche</h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            {steps.map((step, index) => (
              <div key={index} className="text-center">
                <div className="w-12 h-12 rounded-full bg-primary text-primary-foreground flex items-center justify-center text-xl font-bold mx-auto mb-4">
                  {index + 1}
                </div>
                <p className="text-lg">{step}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Benefits */}
      <section className="py-20 px-4 bg-muted/30">
        <div className="container mx-auto">
          <h2 className="text-3xl font-bold text-center mb-12">Bénéfices</h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            {benefits.map((benefit, index) => (
              <Card key={index}>
                <CardHeader>
                  <benefit.icon className="h-10 w-10 text-primary mb-2" />
                  <CardTitle>{benefit.title}</CardTitle>
                </CardHeader>
                <CardContent>
                  <CardDescription>{benefit.description}</CardDescription>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="py-20 px-4">
        <div className="container mx-auto text-center">
          <h2 className="text-4xl font-bold mb-6">
            Prêt à écrire votre prochaine histoire ?
          </h2>
          <Button onClick={() => navigate('/auth')} size="lg" className="text-lg px-8">
            Commencer maintenant
          </Button>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-border py-8">
        <div className="container mx-auto px-4 text-center text-muted-foreground">
          <p>&copy; 2025 Pulse Noir, le Studio. Tous droits réservés.</p>
        </div>
      </footer>
    </div>
  )
}
