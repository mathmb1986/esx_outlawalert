Require sd-aipolice https://github.com/mathmb1986/sd-aipolice

📦 esx_outlawalert – Amélioré & Compatible sd-aipolice
Détection de délits + Alertes Police + UI Niveau de Recherche (NUI)

🚀 Description

esx_outlawalert est un script FiveM basé ESX permettant :

la détection automatique de délits :

Carjacking

Coups de feu

Combat au corps à corps

l’envoi d’alertes aux policiers (notifications + blips temporaires),

la gestion d’un statut Outlaw (recherché) via Decorators,

l’intégration complète avec le système sd-aipolice pour la gestion du Wanted Level,

et une interface NUI moderne affichant le niveau de recherche sous forme d’étoiles ⭐⭐⭐.

Ce fork améliore profondément la version originale pour fonctionner sur les serveurs modernes avec HUD custom et logique policière AI/humaine centralisée.

✨ Fonctionnalités
🔍 Détection intelligente des délits

🔧 Carjacking (vol de véhicule verrouillé)

🔫 Coup de feu (dès qu’un tir est détecté)

👊 Combat (melee)

Délais configurables pour réduire les faux positifs.

👮 Alertes côté Police

Notifications immersives

Blips temporaires configurables :

durée

rayon

couleur

Permet aux policiers d’intervenir directement.

⭐ Interface Wanted Level (NUI)

Affiche automatiquement le niveau de recherche actuel :

Joli UI uniquement composé d’étoiles :

★★★☆☆


Pas de texte inutile

Pas de HUD GTAV requis

Clignotement animé lors d’un changement de niveau

Position configurable (top-right par défaut)

🤖 Compatible AI Police (sd-aipolice)

Ce script s’intègre parfaitement à sd-aipolice, via :

exports :

exports['sd-aipolice']:ApplyWantedLevel(level)


ou event fallback :

TriggerEvent('phade-aipolice:client:ApplyWantedLevel', level)


Cela permet une logique centralisée du Wanted Level :

IA Police si aucun policier joueur

Police humaine si des joueurs sont en service

Wanted Level incrémenté par délit

Synchronisation automatique de l'UI Wanted Level
