# veriloga-flake
Flake for the development and testing of VerilogA compact models.
It provides the VACASK circuit simulator, the OpenVAF Verilog-A compiler, the 
Vampyre Verilog-A syntax checker, the xschem schematic editor and a python 
environment for data analysis and plotting.

## Usage
Make sure you have nix installed and flakes enabled. Then run the following
command, it will automatically download the flake and enter an environment 
with all utilities available.
```sh
nix develop github:ncas-tum/veriloga-flake
```
