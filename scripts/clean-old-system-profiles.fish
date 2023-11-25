#!/usr/bin/env fish

set prefix /nix/var/nix/profiles
set profiles $prefix/system-*-link
set profile $prefix/(readlink $prefix/system)

echo "$profile is current profile"
for i in (seq (count $profiles) | sort -R)
    if test $profiles[$i] != $profile
        sudo rm -i $profiles[$i]
    end
end
