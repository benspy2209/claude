import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatDate(date: Date | string): string {
  const d = typeof date === 'string' ? new Date(date) : date
  return new Intl.DateTimeFormat('fr-FR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }).format(d)
}

export function formatTime(date: Date): string {
  return new Intl.DateTimeFormat('fr-FR', {
    hour: '2-digit',
    minute: '2-digit',
  }).format(date)
}

export function countWords(html: string): number {
  // Remove HTML tags
  const text = html.replace(/<[^>]*>/g, ' ')
  // Remove extra whitespace
  const cleanText = text.replace(/\s+/g, ' ').trim()
  // Count words
  return cleanText.length > 0 ? cleanText.split(' ').length : 0
}

export function wordsToPages(words: number, wordsPerPage: number = 250): number {
  return Math.ceil(words / wordsPerPage)
}
