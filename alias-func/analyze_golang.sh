awk '/results/ {
     file = $2;
     getline;
     units = $2;
     getline ;
     result = $2;
     printf("\t%s\t%s\t%s\n", file, units, result); }'
     < "${1}"analyze_golang.sh