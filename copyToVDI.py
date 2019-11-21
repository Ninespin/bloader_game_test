import struct
import os

asm_filename = 'bootloader.asm'
src_filename = 'bootloader.bin'
dst_filename = 'bootloader/bootloader.vdi'
vdi_boot_offset_addr = 0x158
compile_command_str = 'nasm -f bin -o ' + src_filename + ' ' + asm_filename

print('compiling...')
print('  ' + compile_command_str)
print('compile status: ' + str(os.system(compile_command_str)))
print()

print('src file: ' + src_filename)
print('dst file: ' + dst_filename)
print('VDI boot offset address: ' + hex(vdi_boot_offset_addr));

with open(src_filename, 'rb')as src_f:
    content = src_f.read()
    with open(dst_filename, 'rb+') as dst_f:
        dst_f.seek(vdi_boot_offset_addr)
        vdi_boot_offset = struct.unpack('<I', dst_f.read(4))[0]
        print('found VDI boot offset: ' + hex(vdi_boot_offset));
        dst_f.seek(vdi_boot_offset)
        print('Writing...')
        dst_f.write(content)
        print('Done!')
    
