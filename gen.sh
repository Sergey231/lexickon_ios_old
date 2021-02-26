
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

cd lexickon_ios/Resources/Assets
./swiftgen/bin/swiftgen

if (xcodebuild build -scheme Assets -quiet); then
    printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    echo "\033[0;32m 🎉 You can use new Assets constants! ";
else
    echo "\033[0;31m 😐 New constants was generated BUT Assets package wasn't rebuilt";
fi & spin $!

