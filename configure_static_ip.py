"""
This function takes the following input arguments:
arg1: Number (as in place after the loopback interface) of the interface in the config file #NOT IMPLEMENTED AS OF YET
arg2: Static IP address to assign
arg3: IP address netmask
arg4: Gateway

WARNING: this script can't handle interfaces past the first one and will overwrite them!
"""

import re
import sys

#Load the file
path = "/etc/network/interfaces"

if len(sys.argv) < 3:
    print("Error: not enough input arguments")
    sys.exit(1)


with open(path,'r+') as fh:
  line_counter = 0
  for line in fh.readlines():
      #Use counter to find where to start replacing
      line_counter = line_counter + len(line)+1

      #Search for an interface line
      iface_name = re.search('iface[ ]+(.*)[ ]+inet[ ](.*)|\Z',line)

      #Discard loopback interface
      if iface_name.group(1) == "lo":
          line = line

      elif iface_name.group(1):
          print("Found interface %s" % iface_name.group(1))
          if (iface_name.group(2) == "static"):
              print("%s is already static" % iface_name.group(1))
              break
          else:
              fh.seek(line_counter_prev)
              fh.write("iface %s inet static\n" % iface_name.group(1))
              fh.write("address %s\n" % sys.argv[1])
              fh.write("netmask %s\n" % sys.argv[2])
              fh.write("gateway %s\n" % sys.argv[3])
              print("address %s" % sys.argv[1])
              print("netmask %s" % sys.argv[2])
              print("gateway %s" % sys.argv[3])
              break
      line_counter_prev = line_counter

      print(line_counter)