
spin()
{
    local pid=$1
    local spinner=('Ooooo' 'oOooo' 'ooOoo' 'oooOo' 'ooooO' 'oooOo' 'ooOoo' 'oOooo');
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        
        for i in ${spinner[@]};
        do
            printf "\033[1;34m Building Assets Package... $i"
            local spinstr=$temp${spinstr%"$temp"}
            sleep 0.1
            printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
        done
    done
}

if [[ $(command -v brew) == "" ]]; then
    echo "Installing Hombrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if [[ $(command -v swiftgen) == "" ]]; then
    echo "Installing Swiftgen"
    brew update
    brew install swiftgen
fi

swiftgen
(xcodebuild build -target lexickon_ios -scheme Assets -quiet) & spin $!
echo "\033[0;32m 🎉 New Assets constants have been generated! ";