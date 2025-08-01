# File to Generate FavIcons from an SVG using ImageMagick.
# ImageMagic must be on the path

# Setup input and output paths
$InputFile = "$PSScriptRoot\static\favicon.svg"
$OutputPath = "$PSScriptRoot\static"

# Cleanup any previous entries
Remove-Item @(
    "$OutputPath\favicon-16x16.png"
    "$OutputPath\favicon-32x32.png"
    "$OutputPath\apple-touch-icon.png"
    "$OutputPath\favicon-16.png"
    "$OutputPath\favicon-32.png"
    "$OutputPath\favicon.ico"
) -ErrorAction SilentlyContinue

# Need to supply density so that ImageMagick doesn't use the viewbox of the
# svg as the pixel size at default DPI (which is 32x32).
magick -density 600 $InputFile -resize 16x16 -quality 100 "$OutputPath\favicon-16x16.png"
magick -density 600 $InputFile -resize 32x32 -quality 100 "$OutputPath\favicon-32x32.png"
magick -density 600 $InputFile -resize 180x180 -quality 100 "$OutputPath\apple-touch-icon.png"

# Generate ICO file (contains multiple sizes in one file)
magick -density 600 $InputFile -resize 16x16 -quality 100 "$OutputPath\favicon-16.png"
magick -density 600 $InputFile -resize 32x32 -quality 100 "$OutputPath\favicon-32.png"
magick "$OutputPath\favicon-16.png" "$OutputPath\favicon-32.png" "$OutputPath\favicon.ico"

# Clean up temporary files
Remove-Item "$OutputPath\favicon-16.png", "$OutputPath\favicon-32.png"