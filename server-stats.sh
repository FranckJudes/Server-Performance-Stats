#!/bin/bash

# Vérification des permissions (doit être exécuté en sudo pour certaines commandes)
if [[ $EUID -ne 0 ]]; then
    echo "Ce script doit être exécuté en tant que root (sudo)." 
    exit 1
fi

echo "======================= SERVER STATS ======================="



# Information sur le système
echo -e "\n Système d'exploitation : $(lsb_release -d | cut -f2)"
echo "Version du noyau Linux : $(uname -r)"
echo "Temps d'activité (Uptime) : $(uptime -p)"
echo "Utilisateurs connectés : $(who | wc -l)"



#  Utilisation du CPU
echo -e "\n Utilisation CPU :"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"% utilisé"}')
echo "   🔹 $CPU_USAGE"





# Utilisation de la mémoire RAM
echo -e "\n Utilisation de la mémoire RAM :"
MEMORY=$(free -m)
TOTAL_RAM=$(echo "$MEMORY" | awk 'NR==2{print $2}')
USED_RAM=$(echo "$MEMORY" | awk 'NR==2{print $3}')
FREE_RAM=$(echo "$MEMORY" | awk 'NR==2{print $4}')
PERCENT_RAM=$(awk "BEGIN {printf \"%.2f\", ($USED_RAM/$TOTAL_RAM)*100}")
echo "  Total : ${TOTAL_RAM}MB"
echo "  Utilisée : ${USED_RAM}MB (${PERCENT_RAM}%)"
echo "  Libre : ${FREE_RAM}MB"




#  Utilisation du disque
echo -e "\n Utilisation du disque :"
DISK=$(df -h --total | grep "total")
TOTAL_DISK=$(echo "$DISK" | awk '{print $2}')
USED_DISK=$(echo "$DISK" | awk '{print $3}')
FREE_DISK=$(echo "$DISK" | awk '{print $4}')
PERCENT_DISK=$(echo "$DISK" | awk '{print $5}')
echo "   Total : ${TOTAL_DISK}"
echo "   Utilisé : ${USED_DISK} (${PERCENT_DISK})"
echo "   Libre : ${FREE_DISK}"

# 5️ Top 5 des processus par utilisation du CPU
echo -e "\n Top 5 des processus (CPU) :"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# 6️ Top 5 des processus par utilisation de la mémoire
echo -e "\n Top 5 des processus (Mémoire) :"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

# 7️ Tentatives de connexion échouées
echo -e "\n Tentatives de connexion échouées :"
FAILED_LOGINS=$(grep "Failed password" /var/log/auth.log | wc -l)
echo "   Échecs : ${FAILED_LOGINS} tentatives"

echo -e "\n Analyse terminée !"
