# ionosDnsUpdater 
DSN Update for dns provider like ionos, looks like a DynDSN 
based on the project : https://github.com/Domain-Connect/DomainConnectDDNS-Python  

Take your local IP and send it to ionos if it has changed 

Contenair Docker to periodcaly update the IP adress of my DNS hosted in Ionos 

Modifiez la variable d'environnement DOMAIN pour qu'elle colle à votre Nom de domaine à mettre à jour Modifiez la variable  
TZ pour qu'elle colle avotre Timezone 

Vous pouvez aussi mofifier le declenchement de la verification et mise a jour via la commande crontab du script (par default 5 minutes) 

Aprés avoir lancé le conteneur il faut aller un terminal pour valider le lien avec votre domaine. lancer le script "setupDomain" 

autre option lancer la commande suivante 

domain-connect-dyndns setup --domain xx.votredomaine.com 
 
et suivez les instructions 

Pour construire l'image Docker, lancer la commande 

docker build -t NomDeVotreConteneur --no-cache --force-rm . 

Utilisation du projet : https://github.com/Domain-Connect/domainconnect_python 

# ENVIRONMENT 
DOMAIN = DNS DOMAIN name to be updated 
TZ = TimeZone  
CONFFILE = place to store dns config and key 
CRONDELAY = delay to verify if the ip has changes in minutes  */5 for evry 5 minutes 
