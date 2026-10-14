# Assassin's Creed Freedom Cry 240FPS Patcher

This script patches the selected Assassin's Creed Freedom Cry game executable (`ACFC.exe`) in order to bump the maximum frame rate from 60FPS to 240FPS.

The script creates a backup of the original .exe file in the same directory in which the user selected `ACFC.exe`, named `ACFC.exe.bak`.
Thus, you can revert the patch by deleting `ACFC.exe` and then renaming `ACFC.exe.bak` to `ACFC.exe`.

## Credits

[This patch was created by reverse engineering the patched Assassin's Creed IV: Black Flag executable](https://www.nexusmods.com/assassinscreedivblackflag/mods/453), created by [kamzik123](https://www.nexusmods.com/profile/kamzik123).

Without his original work, this patch would not be possible.

This project also uses the [tinyfiledialogs](https://sourceforge.net/projects/tinyfiledialogs/) C/C++ library, by [Guillaume Vareille](https://sourceforge.net/u/vareille/profile/)
