"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/image2base64.vim
"VERSION:  0.9
"LICENSE:  MIT

if !exists("g:image2base64_comment")
    let g:image2base64_comment = 1
endif

command! -range Image2base64 <line1>,<line2>call i2b64#Exe()
