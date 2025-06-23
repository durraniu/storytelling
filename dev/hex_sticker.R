# ----------------------------------------------------- #
# HexSticker for the {storytelling} package
#
# Notes:
# A) Uses the "hexSticker" package
# ----------------------------------------------------- #

# Packages
library(hexSticker)

# Image file
path_image <- "./dev/image.png"

# Create hexSticker
s <- hexSticker::sticker(subplot = path_image,
                         package = NULL,
                         s_x = 1, s_y = 1, s_width = 0.6, s_height = 0.6,
                         h_fill = "#363565", h_color = "orange",
                         dpi = 1000,
                         filename = "./man/figures/hex_sticker.png",
                         white_around_sticker = F)
# -------------------- END OF CODE -------------------- #
