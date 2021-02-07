
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

cd lexickon_ios/Resources/Assets
swiftgen
if (xcodebuild build -target lexickon_ios -scheme Assets -quiet); then
    printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    echo "\033[0;32m 🎉 You can use new Assets constants! ";
else
    echo "\033[0;31m 😐 New constants was generated BUT Assets package wasn't rebuilt";
fi & spin $!

