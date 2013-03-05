# Copyright (c) 2013, Sowicm
# All rights reserved.
#
# Redistribution and use in source and text forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# * Redistributions in text form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# THIS MODULE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS MODULE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

include GamePath.txt

all: \
txt \
txt/variables.txt \
txt/variable_uses.txt \
txt/actions.txt \
txt/conversation.txt \
txt/dialog_states.txt \
txt/triggers.txt \
txt/factions.txt \
txt/menus.txt \
txt/info_pages.txt \
txt/item_kinds1.txt \
txt/map_icons.txt \
txt/meshes.txt \
txt/mission_templates.txt \
txt/music.txt \
txt/particle_systems.txt \
txt/parties.txt \
txt/party_templates.txt \
txt/postfx.txt \
txt/presentations.txt \
txt/quests.txt \
txt/scene_props.txt \
txt/scenes.txt \
txt/scripts.txt \
txt/simple_triggers.txt \
txt/skills.txt \
txt/skins.txt \
txt/sounds.txt \
txt/strings.txt \
txt/tableau_materials.txt \
txt/troops.txt

zip: dist
	cd dist && zip -ru latest.zip iNad

install: dist
	cp -ru dist/iNad $(GamePath)

dist: all
	-mkdir dist
	-mkdir dist/iNad
	cp -ru txt/* dist/iNad
	cp -ru data/* dist/iNad
	# xcopy "txt\*" "dist\iNad\" /D /E /V /K /Y
	# xcopy "data\*" "dist\iNad\" /D /E /V /K /Y

txt:
	mkdir txt

txt/variables.txt txt/variable_uses.txt: processes/process_init.py src/variables.txt
	python $<

txt/actions.txt: processes/process_animations.py src/modules/module_animations.py
	python $<

txt/conversation.txt txt/dialog_states.txt txt/triggers.txt: \
	processes/process_dialogs.py src/modules/module_triggers.py \
	src/modules/module_dialogs.py src/dialogs/*.py \
	txt/troops.txt txt/party_templates.txt
	python $<

txt/factions.txt: processes/process_factions.py src/modules/module_factions.py
	python $<

txt/menus.txt: processes/process_game_menus.py src/modules/module_game_menus.py src/menus/*.py
	python $<

txt/info_pages.txt: processes/process_info_pages.py src/modules/module_info_pages.py
	python $<

txt/item_kinds1.txt: processes/process_items.py src/modules/module_items.py
	python $<

txt/map_icons.txt: processes/process_map_icons.py src/modules/module_map_icons.py
	python $<

txt/meshes.txt: processes/process_meshes.py src/modules/module_meshes.py
	python $<

txt/mission_templates.txt: processes/process_mission_tmps.py src/modules/module_mission_templates.py
	python $<

txt/music.txt: processes/process_music.py src/modules/module_music.py
	python $<

txt/particle_systems.txt: processes/process_particle_sys.py src/modules/module_particle_systems.py
	python $<

txt/parties.txt: processes/process_parties.py src/modules/module_parties.py
	python $<

txt/party_templates.txt: processes/process_party_tmps.py src/modules/module_party_templates.py
	python $<

txt/postfx.txt: processes/process_postfx.py src/modules/module_postfx.py
	python $<

txt/presentations.txt: processes/process_presentations.py src/modules/module_presentations.py
	python $<

txt/quests.txt: processes/process_quests.py src/modules/module_quests.py
	python $<

txt/scene_props.txt: processes/process_scene_props.py src/modules/module_scene_props.py
	python $<

txt/scenes.txt: processes/process_scenes.py src/modules/module_scenes.py
	python $<

txt/scripts.txt: processes/process_scripts.py src/modules/module_scripts.py src/scripts/*.py
	python $<

txt/simple_triggers.txt: processes/process_simple_triggers.py src/modules/module_simple_triggers.py
	python $<

txt/skills.txt: processes/process_skills.py src/modules/module_skills.py
	python $<

txt/skins.txt: processes/process_skins.py src/modules/module_skins.py
	python $<

txt/sounds.txt: processes/process_sounds.py src/modules/module_sounds.py
	python $<

txt/strings.txt: processes/process_strings.py src/modules/module_strings.py
	python $<

txt/tableau_materials.txt: processes/process_tableau_materials.py src/modules/module_tableau_materials.py
	python $<

txt/troops.txt: processes/process_troops.py src/modules/module_troops.py
	python $<

clean:
	-del /s *.pyc
	-rd /s /q txt

distclean: clean
	-rd /s /q dist

.PHONY: all zip clean distclean
