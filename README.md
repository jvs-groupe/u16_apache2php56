Apache2 & PHP5.6 webServer
---

Serveur web apache avec PHP5.6 sous ubuntu 16.04

# Utilisation

## Docker

```
    
    // Pour générer l'image
    make build
    
    // Pour lancer le container
    make run
    
    // Pour arrêter le container
    make stop
    
    // Pour accéder en ssh
    make bash
    
```

## Url d'accès

```

    http://localhost:8883

```

## Divers

Les logs du serveur se retrouveront dans le répertoire docker-logs.
Ce répertoire est à exlure de git (cf .gitignore)

Variables docker :
* DOCUMENTROOT : par défaut www
* ERRORLOG : par défaut error.log
* ACCESSLOG : par défaut access.log
* SERVERNAME : par défaut apache2php7.local.fr
* APP_SERVERNAME : par défaut localhost
* COMPOSERS : liste des répertoires pour lancer un composer, séparés par :
* BOWERS : liste des répertoires pour lancer un bower, séparés par :

--