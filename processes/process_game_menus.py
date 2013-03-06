import string
import types

from process_common import *
from module_info import *
from module_game_menus import *

from process_operations import *

## iNad begin ##
def upgrade_game_menus():
  lfile = open("data/languages/cns/game_menus_native.csv", "r")
  csv = {}
  for line in lfile:
    csv_id = ""
    part = 1
    for i in xrange(len(line)):
      if part == 1:
        if line[i] == '|':
          part = 2
          csv[csv_id] = ""
        else:
          csv_id += line[i]
      else:
        if line[i] != '\r' and line[i] != '\n':
          csv[csv_id] += line[i]
  lfile.close()
  file = open("upgrade_game_menus.sh", "w")
  for game_menu in game_menus:
    csv_id = "menu_" + game_menu[0]
    if csv_id in csv.keys():
      if game_menu[2][0] != '-':
        file.write("sed -i \"s/\\\"%s\\\"/\\\"-%s\\\"/g\" ./module_game_menus.py\n"%(game_menu[2],string.replace(csv[csv_id]," ","")))
      else:
        print "Missing key:%s"%(csv_id)
    for menu_item in game_menu[5]:
      csv_id = "mno_" + menu_item[0]
      if csv_id in csv.keys():
        if menu_item[2][0] != '-':
          file.write("sed -i \"s/\\\"%s\\\"/\\\"-%s\\\"/\" ./module_game_menus.py\n"%(menu_item[2],string.replace(csv[csv_id]," ","")))
        else:
          print "Missing key:%s"%(csv_id)
  file.close()
## iNad end ##

def save_game_menu_item(ofile,cnfile,variable_list,variable_uses,menu_item,tag_uses,quick_strings):
  ofile.write(" mno_%s "%(menu_item[0]))
  save_statement_block(ofile,0, 1, menu_item[1], variable_list, variable_uses,tag_uses,quick_strings)
  ## iNad begin ##
  if menu_item[2][0] == '-':
    ofile.write(" Chinese_Only ")
    cnfile.write("mno_%s|"%(menu_item[0]))
    k = 0
    for j in xrange(1, len(menu_item[2])):
      char = menu_item[2][j]
      cnfile.write(char)
      if (ord(char) & 128 == 128):
        if (ord(char) & 192 == 128):
          if j == k:
            cnfile.write(" ")
        elif (ord(char) & 224 == 192):
          k = j + 1
        elif (ord(char) & 240 == 224):
          k = j + 2
        elif (ord(char) & 248 == 240):
          k = j + 3
        elif (ord(char) & 252 == 248):
          k = j + 4
        elif (ord(char) & 254 == 252):
          k = j + 5
    cnfile.write("\n")
  else:
    ofile.write(" %s "%(string.replace(menu_item[2]," ","_")))
  ## iNad end ##
  save_statement_block(ofile,0, 1, menu_item[3], variable_list, variable_uses,tag_uses,quick_strings)
  door_name = "."
  if (len(menu_item) > 4):
    door_name = menu_item[4]
  ofile.write(" %s "%(string.replace(door_name," ","_")))

def save_game_menus(variable_list,variable_uses,tag_uses,quick_strings):
  #upgrade_game_menus()
  ofile = open(export_dir + "menus.txt","w")
  ofile.write("menusfile version 1\n")
  ofile.write(" %d\n"%(len(game_menus)))
  cnfile = open("data/languages/cns/game_menus.csv", "w")
  for game_menu in game_menus:
    ## iNad begin ##
    if game_menu[2][0] == '-':
      ofile.write("menu_%s %d Chinese_Only %s"%(game_menu[0],game_menu[1],game_menu[3]))
      cnfile.write("menu_%s|"%(game_menu[0]))
      k = 0
      for j in xrange(1, len(game_menu[2])):
        char = game_menu[2][j]
        cnfile.write(char)
        if (ord(char) & 128 == 128):
          if (ord(char) & 192 == 128):
            if j == k:
              cnfile.write(" ")
          elif (ord(char) & 224 == 192):
            k = j + 1
          elif (ord(char) & 240 == 224):
            k = j + 2
          elif (ord(char) & 248 == 240):
            k = j + 3
          elif (ord(char) & 252 == 248):
            k = j + 4
          elif (ord(char) & 254 == 252):
            k = j + 5
      cnfile.write("\n")
    else:
      ofile.write("menu_%s %d %s %s"%(game_menu[0],game_menu[1],string.replace(game_menu[2]," ","_"),game_menu[3]))
    ## iNad end ##

    save_statement_block(ofile,0,1, game_menu[4]  , variable_list, variable_uses,tag_uses,quick_strings)
    menu_items = game_menu[5]
    ofile.write("%d\n"%(len(menu_items)))
    for menu_item in menu_items:
      save_game_menu_item(ofile,cnfile,variable_list,variable_uses,menu_item,tag_uses,quick_strings)
    ofile.write("\n")
  ofile.close()
  cnfile.close()

def save_python_header():
  ofile = open("ids/ID_menus.py","w")
  for i_game_menu in xrange(len(game_menus)):
    ofile.write("menu_%s = %d\n"%(game_menus[i_game_menu][0],i_game_menu))
  ofile.close()

print "Exporting game menus data..."
save_python_header()
variable_uses = []
variables = load_variables(export_dir, variable_uses)
tag_uses = load_tag_uses(export_dir)
quick_strings = load_quick_strings(export_dir)
save_game_menus(variables,variable_uses,tag_uses,quick_strings)
save_variables(export_dir,variables,variable_uses)
save_tag_uses(export_dir, tag_uses)
save_quick_strings(export_dir,quick_strings)
