
echo "--------------------------------------------------"
echo "     STARTING ARCH LINUX SYSTEM UPDATE..."
echo "--------------------------------------------------"

sudo pacman -Syu

if [ $? -eq 0 ]; then
  echo ""
  echo "System Update completed successfully!"
else
  echo ""
  echo "System Update encountered errors. Check output above."
fi

echo ""
echo "--------------------------------------------------"
echo "     CLEANING PACMAN CACHE..."
echo "--------------------------------------------------"

pacman -Sc

echo ""
echo "--------------------------------------------------"
echo "     REMOVING ORPHANED PACKAGES..."
echo "--------------------------------------------------"

pacman -Qdtq | sudo pacman -Rns - --noconfirm
