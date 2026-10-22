# DarMate — Plateforme de Colocation Étudiante 

Infrastructure Cloud résiliente, sécurisée et 100% reproductible par code sur AWS.

## Architecture Déployée 
- **Réseau :** VPC dédié sur `us-east-1` avec 6 sous-réseaux (Publics, Privés App, Privés Données) répartis sur 2 Zones de Disponibilité (`us-east-1a` et `us-east-1b`).
- **Accès Sortant :** 1 NAT Gateway managée en Zone A (compromis validé pour budget 50$).
- **Sécurité :** Chaînage strict des Security Groups `sg-alb (80)` -> `sg-Front (80)` -> `sg-app (80)` -> `sg-db (3306)`.
- **Calcul :** 1 Application Load Balancer public et 1 instance EC2 `t3.micro` en sous-réseau privé avec `LabInstanceProfile`.

## Procédure de Déploiement

### 1. Charger les identifiants AWS Academy
Dans votre terminal PowerShell :
```powershell
$env:AWS_ACCESS_KEY_ID="VOTRE_ACCESS_KEY"
$env:AWS_SECRET_ACCESS_KEY="VOTRE_SECRET_KEY"
$env:AWS_SESSION_TOKEN="VOTRE_SESSION_TOKEN"
$env:AWS_DEFAULT_REGION="us-east-1"
```

### 2. Déployer l'infrastructure
cd infra
terraform init
terraform apply -auto-approve

### 3. Tester la démonstration

### 4. Destruction systématique en fin de séance
cd ../scripts
./destroy.ps1

