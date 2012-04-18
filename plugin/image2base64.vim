"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/image2base64.vim
"VERSION:  0.9
"LICENSE:  MIT

if exists("g:loaded_image2base64")
    finish
endif
let g:loaded_image2base64 = 1

let s:save_cpo = &cpo
set cpo&vim

command! -range Image2base64 <line1>,<line2>call i2b64#Exe()

let &cpo = s:save_cpo
