cd ~/git/nixpkgs/pkgs/by-name/wa/warp-terminal
git checkout upstream-master
git pull --all --rebase
echo ""
echo "$(git --no-pager log -1 --format=%cd --date=local)"
echo ""
git reset --hard upstream/master
git push
./update.sh
cp versions.json ~/dotfiles/nixos/warp-terminal/versions.json
cd ~/dotfiles/nixos/warp-terminal/
echo "$(git diff versions.json)"
