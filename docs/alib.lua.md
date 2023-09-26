# alib.lua wiki

## Simple functions
### loadingBar(procent,title,subTitle,ResetX,ResetY)
Example: `loadingBar(5,"tutorial","reading",1,1)`


Returns: `true`
### reset(resetColor)
Example: `reset(colors.pink)`


Returns: `true`
### readFile(path)
Example: `readFile("example.txt")`


Returns: `{"file contents","divided by line"}`
### BinaryToDecimal(binary)
Example: `BinaryToDecimal(10100111001)`


Returns: `1337`
### DecimalToHex(decimal)
Example: `DecimalToHex(13371337)`


Returns: `CC07C9`
### printCenter(str,centerVert,customY)
Example: `printCenter("HI!",true,5)`


Returns: `true`
## Advanced functions
### CharcodeFile(path,output)
Example: `CharcodeFile("example.txt","output.txt")`


This function encodes the input file using `string.byte()` and saves
the result in the `output` path.
### UnCharcodeFile(path,output)
Example: `CharcodeFile("example.txt","output.txt")`


This function decodes the input file using `string.char()` and saves
the result in the `output` path.
### CharfileToHexfile(path,output)
Example: `CharfileToHexfile("example.txt","output.txt")`


This function encodes the input char encoded file to hexadecimal and saves
the result in the `output` path.
### HexfileToACHF(path,output)
Example: `HexfileToACHF("example.txt","output.txt")`


This function encodes the input hexadecimal encoded file to a special ACHF file encoding
and saves the result in the `output` path.
### ACHFToHexfile(path,output)
Example: `HexfileToACHF("example.txt","output.txt")`


This function decodes the input ACHF file to hexadecimal
and saves the result in the `output` path.
