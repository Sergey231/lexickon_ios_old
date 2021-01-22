
spinner()
{
    local pid=$1
    local delay=0.5
    local spinstr='\|/-'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " \033[1;34m[\033[1;34m%c]" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
}

swiftgen
(xcodebuild build -target lexickon_ios -scheme Assets -quiet) &
spinner $!
echo "\033[0;32m 🎉 New Assets constants have been generated! ";


