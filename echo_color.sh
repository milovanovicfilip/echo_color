#!/opt/homebrew/bin/bash

CHART[0]="     _/  _/    _/_/_/_/              _/                    "
CHART[1]="  _/_/_/_/_/  _/          _/_/_/    _/     _/_/_/     _/_/ "
CHART[2]="   _/  _/    _/        _/      _/  _/   _/      _/   _/  _/"
CHART[3]="_/_/_/_/_/  _/        _/      _/  _/   _/      _/   _/     "
CHART[4]=" _/  _/    _/_/_/_/    _/_/_/    _/_/   _/_/_/     _/      "


help() {
    echo
    for line in "${CHART[@]}"; do
	    echo -e "\e[36m$line\e[0m"
    done
	
    echo
    echo "Uporaba: echo_color [-bourvmh] [besedilo]"
    echo "Možnosti:"
    echo "  -b [barva]              Nastavi barvo besedila (npr. crna, rdeca, zelena, rumena, modra, magenta, cian, bela)"
    echo "  -o [barva ozadja]       Nastavi barvo ozadja (npr. crna, rdeca, zelena, rumena, modra, magenta, cian, bela)"
    echo "  -u [oblika]             Nastavi učinek (npr. krepko, lezece, podcrtano, obrnjeno, skrivno)"
    echo "  -r			    Nastavi možnost obrnenjenega izpisa"
    echo "  -v			    Nastavi možnost izpisa toUpper"
    echo "  -m                      Nastavi možnost izpisa toLower"
    echo "  -h                      Prikaži to pomoč in izhod"
    echo 
    echo "Primer uporabe:"
    echo "  echo_color -b modra -o rumena -f krepko 'Besedilo'"
    echo -e "\e[31mPomembno: Ukaz je narejen tako da so vse funkcionalnosti podprte v GNU bash, version 5.2.37.1-release aarch64-apple-darwin24.0.0, kar ne pomeni da isto velja za vse terminale!\e[0m"
}


declare -A barve=(
    [crna]=0 [rdeca]=1 [zelena]=2 [rumena]=3 [modra]=4 [magenta]=5 [cian]=6 [bela]=7
)

declare -A ucinki=(
    [krepko]=1 [lezece]=3 [podcrtano]=4 [obrnjeno]=7 [skrivno]=8
)

barva_besedila=""
barva_ozadja=""
ucinek_besedila=""
obrnjeno=false
to_upper=false
to_lower=false

while getopts "b:o:u:rvmh" opt; do
    case $opt in
        b)
            if [[ -n ${barve[$OPTARG]} ]]; then
                barva_besedila="\e[3${barve[$OPTARG]}m"
            else
               echo -e "\e[31mNapaka: Neveljavna barva.\e[0m"
                exit 1
            fi
            ;;
        o)
            if [[ -n ${barve[$OPTARG]} ]]; then
                barva_ozadja="\e[4${barve[$OPTARG]}m"
            else
                echo -e "\e[31mNapaka: Neveljavna barva.\e[0m"
                exit 1
            fi
            ;;
        u)
            if [[ -n ${ucinki[$OPTARG]} ]]; then
                ucinek_besedila="\e[${ucinki[$OPTARG]}m"
            else
                echo -e "\e[31mNapaka: Neveljaven učinek.\e[0m"
                exit 1
            fi
            ;;
        r)
            obrnjeno=true
            ;;
        v)
            if [[ $to_lower == true ]]; then
                echo -e "\e[31mOpozorilo: Ne morete istocasno uporabljat toUpper in toLower, bo upoštevana tista opcija, ki je nazadnje napisana.\e[0m"
            fi
            to_upper=true
            ;;
        m)
            if [[ $to_upper == true ]]; then
                echo -e "\e[33mOpozorilo: Ne morete istocasno uporabljat toUpper in toLower, bo upoštevana tista opcija, ki je nazadnje napisana.\e[0m"
            fi
            to_lower=true
            ;;
        h)
            help
            exit 0
            ;;
        *)
            help
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

if [[ $# -eq 0 ]]; then
    echo -e "\e[31mNapaka: Ni podanega besedila.\e[0m"
    exit 1
fi

besedilo="$*"

if [[ $obrnjeno == true ]]; then
    besedilo=$(echo "$besedilo" | rev)
fi

if [[ $to_upper == true ]]; then
    besedilo=$(echo "$besedilo" | tr 'a-z' 'A-Z')
fi

if [[ $to_lower == true ]]; then
    besedilo=$(echo "$besedilo" | tr 'A-Z' 'a-z')
fi

echo -e "${ucinek_besedila}${barva_besedila}${barva_ozadja}${besedilo}\e[0m"
