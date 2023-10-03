{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".imx477;
in
{
  options.hardware = {
    raspberry-pi."4".imx477 = {
      enable = lib.mkEnableOption ''
        Enable the Sony IMX477 camera (used in the Raspberry Pi High Quality
        Camera).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Configure for modesetting in the device tree
    hardware.deviceTree = {
      overlays = [
        # this *should* be equivalent to (which doesn't work):
        # https://github.com/raspberrypi/linux/blob/rpi-6.1.y/arch/arm/boot/dts/overlays/imx477-overlay.dts
        # (and included) but actually it's obtained using
        # dtc -I dtb -O dts ${config.hardware.deviceTree.kernelPackage}/dtbs/overlays/imx477.dtbo
        # (changes: modified top-level "compatible" field)
        # which is slightly different and works
        {
          name = "imx477-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;
            
            / {
            	compatible = "brcm,bcm2711";
            
            	fragment@0 {
            		target = <0xffffffff>;
            
            		__overlay__ {
            			status = "okay";
            		};
            	};
            
            	fragment@1 {
            		target = <0xffffffff>;
            		phandle = <0x07>;
            
            		__overlay__ {
            			clock-frequency = <0x16e3600>;
            			status = "okay";
            			phandle = <0x09>;
            		};
            	};
            
            	fragment@2 {
            		target = <0xffffffff>;
            
            		__overlay__ {
            			status = "okay";
            		};
            	};
            
            	fragment@3 {
            		target = <0xffffffff>;
            		phandle = <0x08>;
            
            		__overlay__ {
            			startup-delay-us = <0x493e0>;
            			phandle = <0x0a>;
            		};
            	};
            
            	fragment@100 {
            		target = <0xffffffff>;
            		phandle = <0x05>;
            
            		__overlay__ {
            			#address-cells = <0x01>;
            			#size-cells = <0x00>;
            			status = "okay";
            
            			imx477@1a {
            				reg = <0x1a>;
            				status = "okay";
            				clocks = <0xffffffff>;
            				clock-names = "xclk";
            				VANA-supply = <0xffffffff>;
            				VDIG-supply = <0xffffffff>;
            				VDDL-supply = <0xffffffff>;
            				rotation = <0xb4>;
            				orientation = <0x02>;
            				compatible = "sony,imx477";
            				phandle = <0x03>;
            
            				port {
            
            					endpoint {
            						clock-lanes = <0x00>;
            						data-lanes = <0x01 0x02>;
            						clock-noncontinuous;
            						link-frequencies = <0x00 0x1ad27480>;
            						remote-endpoint = <0x01>;
            						phandle = <0x02>;
            					};
            				};
            			};
            		};
            	};
            
            	fragment@101 {
            		target = <0xffffffff>;
            		phandle = <0x06>;
            
            		__overlay__ {
            			status = "okay";
            			brcm,media-controller;
            			phandle = <0x04>;
            
            			port {
            
            				endpoint {
            					remote-endpoint = <0x02>;
            					clock-lanes = <0x00>;
            					data-lanes = <0x01 0x02>;
            					clock-noncontinuous;
            					phandle = <0x01>;
            				};
            			};
            		};
            	};
            
            	__overrides__ {
            		rotation = [00 00 00 03 72 6f 74 61 74 69 6f 6e 3a 30 00];
            		orientation = [00 00 00 03 6f 72 69 65 6e 74 61 74 69 6f 6e 3a 30 00];
            		media-controller = [00 00 00 04 62 72 63 6d 2c 6d 65 64 69 61 2d 63 6f 6e 74 72 6f 6c 6c 65 72 3f 00];
            		cam0 = [00 00 00 05 74 61 72 67 65 74 3a 30 3d 00 ff ff ff ff 00 00 00 06 74 61 72 67 65 74 3a 30 3d 00 ff ff ff ff 00 00 00 07 74 61 72 67 65 74 3a 30 3d 00 ff ff ff ff 00 00 00 08 74 61 72 67 65 74 3a 30 3d 00 ff ff ff ff 00 00 00 03 63 6c 6f 63 6b 73 3a 30 3d 00 ff ff ff ff 00 00 00 03 56 41 4e 41 2d 73 75 70 70 6c 79 3a 30 3d 00 ff ff ff ff];
            	};
            
            	__symbols__ {
            		clk_frag = "/fragment@1";
            		cam_clk = "/fragment@1/__overlay__";
            		reg_frag = "/fragment@3";
            		cam_reg = "/fragment@3/__overlay__";
            		i2c_frag = "/fragment@100";
            		cam_node = "/fragment@100/__overlay__/imx477@1a";
            		cam_endpoint = "/fragment@100/__overlay__/imx477@1a/port/endpoint";
            		csi_frag = "/fragment@101";
            		csi = "/fragment@101/__overlay__";
            		csi_ep = "/fragment@101/__overlay__/port/endpoint";
            	};
            
            	__fixups__ {
            		i2c0if = "/fragment@0:target:0";
            		cam1_clk = "/fragment@1:target:0\0/fragment@100/__overlay__/imx477@1a:clocks:0";
            		i2c0mux = "/fragment@2:target:0";
            		cam1_reg = "/fragment@3:target:0\0/fragment@100/__overlay__/imx477@1a:VANA-supply:0";
            		i2c_csi_dsi = "/fragment@100:target:0";
            		cam_dummy_reg = "/fragment@100/__overlay__/imx477@1a:VDIG-supply:0\0/fragment@100/__overlay__/imx477@1a:VDDL-supply:0";
            		csi1 = "/fragment@101:target:0";
            		i2c_vc = "/__overrides__:cam0:14";
            		csi0 = "/__overrides__:cam0:32";
            		cam0_clk = "/__overrides__:cam0:50\0/__overrides__:cam0:86";
            		cam0_reg = "/__overrides__:cam0:68\0/__overrides__:cam0:109";
            	};
            
            	__local_fixups__ {
            
            		fragment@100 {
            
            			__overlay__ {
            
            				imx477@1a {
            
            					port {
            
            						endpoint {
            							remote-endpoint = <0x00>;
            						};
            					};
            				};
            			};
            		};
            
            		fragment@101 {
            
            			__overlay__ {
            
            				port {
            
            					endpoint {
            						remote-endpoint = <0x00>;
            					};
            				};
            			};
            		};
            
            		__overrides__ {
            			rotation = <0x00>;
            			orientation = <0x00>;
            			media-controller = <0x00>;
            			cam0 = <0x00 0x12 0x24 0x36 0x48 0x5a>;
            		};
            	};
            };
          '';
        }
      ];
    };
  };
}
