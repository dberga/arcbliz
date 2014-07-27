
################TRAINER FIXES
/* import all needed entries */
INSERT IGNORE INTO `trainer_defs` (`entry`) SELECT DISTINCT(`entry`) FROM `trainer_spells`;
/* remove outdated entries */
DELETE FROM `trainer_defs` WHERE `entry` NOT IN (SELECT DISTINCT(`entry`) FROM `trainer_spells`);

/* req_class */
UPDATE `trainer_defs` SET `req_class` = '0';
UPDATE `trainer_defs` JOIN `creature_names` USING (`entry`) SET `req_class` = '1' WHERE `subname` = 'Warrior Trainer';
UPDATE `trainer_defs` JOIN `creature_names` USING (`entry`) SET `req_class` = '2' WHERE `subname` = 'Paladin Trainer' OR `subname` = 'Triumvirate of the Hand';
UPDATE `trainer_defs` JOIN `creature_names` USING (`entry`) SET `req_class` = '3' WHERE `subname` = 'Hunter Trainer' OR `subname` = 'Pet Trainer';
UPDATE `trainer_defs` JOIN `creature_names` USING (`entry`) SET `req_class` = '4' WHERE `subname` = 'Rogue Trainer' OR `subname` = 'Grand Master Rogue';
UPDATE `trainer_defs` JOIN `creature_names` USING (`entry`) SET `req_class` = '5' WHERE `subname` = 'Priest Trainer' OR `subname` = 'High Priest';
UPDATE `trainer_defs` JOIN `trainer_spells` USING (`entry`) SET `req_class` = '6' WHERE `learn_spell` = '49998'; -- Death Strike Rank 1 - indicates Death Knight
UPDATE `trainer_defs` JOIN `creature_names` USING (`entry`) SET `req_class` = '7' WHERE `subname` = 'Shaman Trainer';
UPDATE `trainer_defs` JOIN `creature_names` USING (`entry`) SET `req_class` = '8' WHERE `subname` = 'Mage Trainer' OR `subname` = 'Master Mage' OR `subname` = 'Portal Trainer';
UPDATE `trainer_defs` JOIN `creature_names` USING (`entry`) SET `req_class` = '9' WHERE `subname` = 'Warlock Trainer' OR `entry` = '6251';
UPDATE `trainer_defs` JOIN `creature_names` USING (`entry`) SET `req_class` = '11' WHERE `subname` = 'Druid Trainer';

/* trainer_type (0 - class, 1 - riding, 2 - profession, 3 - pet) */
UPDATE `trainer_defs` SET `trainer_type` = '0' WHERE `req_class` != '0';
UPDATE `trainer_defs` JOIN `trainer_spells` USING (`entry`) SET `trainer_type`= '1' WHERE `cast_spell` IN ('33389','33392','34092','34093','54198');
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`) SET `trainer_type` = '2'
  WHERE `cast_spell` IN ('3279','2551','7733') OR -- first aid/cooking/fishing apprentice
    `reqskill` IN ('129','164','165','171','182','185','186','197','202','333','356','393','755','773'); -- all professions
UPDATE `trainer_defs` JOIN `creature_names` USING(`entry`) SET `trainer_type` = '2' WHERE `subname` = 'Weapon Master';
UPDATE `trainer_defs` JOIN `creature_names` USING(`entry`) SET `trainer_type` = '3' WHERE `subname` = 'Pet Trainer';

/* can_train_gossip_texid and cannot_train_gossip_textid */
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '1040', `cannot_train_gossip_textid` = '5721'  WHERE `req_class` = '1';
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '3974', `cannot_train_gossip_textid` = '3976'  WHERE `req_class` = '2';
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '4864', `cannot_train_gossip_textid` = '5839'  WHERE `req_class` = '3';
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '4835', `cannot_train_gossip_textid` = '4797'  WHERE `req_class` = '4';
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '4438', `cannot_train_gossip_textid` = '12546' WHERE `req_class` = '5';
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '5005', `cannot_train_gossip_textid` = '5006'  WHERE `req_class` = '7';
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '538',  `cannot_train_gossip_textid` = '539'   WHERE `req_class` = '8';
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '5835', `cannot_train_gossip_textid` = '5836'  WHERE `req_class` = '9';
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '4775', `cannot_train_gossip_textid` = '4774'  WHERE `req_class` = '11'; -- all Druid Trainers
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '4782', `cannot_train_gossip_textid` = '4781'  WHERE `req_class` = '11' AND `entry` IN (SELECT `entry` FROM `creature_proto` WHERE `faction` = '80'); -- Darnassian Druid Trainers
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '6160', `cannot_train_gossip_textid` = '2037'  WHERE `req_class` = '11' AND `entry` IN (SELECT `entry` FROM `creature_proto` WHERE `faction` = '994'); -- Cenarion Circle's Druid Trainers
UPDATE `trainer_defs` SET `can_train_gossip_textid` = '5838', `cannot_train_gossip_textid` = '5839'  WHERE `trainer_type` = '3';

/* trainer_ui_window_message */
UPDATE `trainer_defs` JOIN `creature_names` USING(`entry`)
  SET `trainer_ui_window_message` = "Hello! Can I teach you something?"
  WHERE `subname` = 'Weapon Master' OR `trainer_type` IN ('1', '3');
UPDATE `trainer_defs`
  SET `trainer_ui_window_message` = "Hello, $c! Ready for some training?"
  WHERE `trainer_type` = '0' AND `req_class` != '6';
UPDATE `trainer_defs`
  SET `trainer_ui_window_message` = "Well met, $c. Ready for some training?"
  WHERE `trainer_type` = '0' AND `req_class` = '6';
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "Here, let me show you how to bind those wounds...."
  WHERE `reqskill` = '129'; -- first aid trainers
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "You are a cut above the rest.  Ouch."
  WHERE `reqskill` = '129' AND `reqskillvalue` >= '350'; -- grand master first aid trainers
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "Care to learn how to turn the ore that you find into weapons and metal armor?"
  WHERE `reqskill` = '164'; -- blacksmiths
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "Greetings! Can I teach you how to turn beast hides into armor?"
  WHERE `reqskill` = '165'; -- leatherworkers
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "With alchemy you can turn found herbs into healing and other types of potions."
  WHERE `reqskill` = '171'; -- alchemists
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "The herbs of Northrend can be brewed into powerful potions. Do you wish to learn?"
  WHERE `reqskill` = '171' AND `reqskillvalue` >= '350'; -- grand master alchemists
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "Searching for herbs requires both knowledge and instinct."
  WHERE `reqskill` = '182'; -- herbalists
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "Can I teach you how to turn the meat you find on beasts into a feast?"
  WHERE `reqskill` = '185'; -- cooks
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "You have not lived until you have dug deep into the earth."
  WHERE `reqskill` = '186'; -- miners
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "Greetings! Can I teach you how to turn found cloth into cloth armor?"
  WHERE `reqskill` = '197'; -- tailors
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "Engineering is very simple once you grasp the basics."
  WHERE `reqskill` = '202'; -- engineers
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "The flying machine is an amazing device!"
  WHERE `learn_spell` = '44157'; -- turbo-charged flying machine teachers
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "Enchanting is the art of improving existing items through magic."
  WHERE `reqskill` = '333'; -- enchanters
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "I can teach you how to use a fishing pole to catch fish."
  WHERE `reqskill` = '356'; -- fishers
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "I can teach you the finer points of fishing."
  WHERE `reqskill` = '356' AND `reqskillvalue` >= '350'; -- grand master fishers
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "It requires a steady hand to remove the leather from a slain beast."
  WHERE `reqskill` = '393'; -- skinners
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "Greetings! Can I teach you how to cut precious gems and craft jewelry?"
  WHERE `reqskill` = '755'; -- jewelcrafters
UPDATE `trainer_defs` JOIN `trainer_spells` USING(`entry`)
  SET `trainer_ui_window_message` = "Would you like to learn the intricacies of inscription?"
  WHERE `reqskill` = '773'; -- scribes

################################################################################################################
#Death Comes From On High (gameobject eye of acherus enabled spell)
	UPDATE quests SET ReqItemId1=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemId2=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemId3=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemId4=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemId5=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemId6=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemCount1=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemCount2=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemCount3=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemCount4=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemCount5=0 WHERE entry = 12641;
	UPDATE quests SET ReqItemCount6=0 WHERE entry = 12641;
	UPDATE quests SET ReqKillMobOrGOId1=0 WHERE entry = 12641;
	UPDATE quests SET ReqKillMobOrGOId2=0 WHERE entry = 12641;
	UPDATE quests SET ReqKillMobOrGOId3=0 WHERE entry = 12641;
	UPDATE quests SET ReqKillMobOrGOId4=0 WHERE entry = 12641;
	UPDATE quests SET ReqKillMobOrGOCount1=0 WHERE entry = 12641;
	UPDATE quests SET ReqKillMobOrGOCount2=0 WHERE entry = 12641;
	UPDATE quests SET ReqKillMobOrGOCount3=0 WHERE entry = 12641;
	UPDATE quests SET ReqKillMobOrGOCount4=0 WHERE entry = 12641;
	UPDATE quests SET ReqCastSpellId1=0 WHERE entry = 12641;
	UPDATE quests SET ReqCastSpellId2=0 WHERE entry = 12641;
	UPDATE quests SET ReqCastSpellId3=0 WHERE entry = 12641;
	UPDATE quests SET ReqCastSpellId4=0 WHERE entry = 12641;
	update creature_proto set spell3 = 51900 where entry = 28511;
	update gameobject_spawns set Flags = 6553600 where entry = 191609;
	update gameobject_names set spellfocus = 51852, Type = 22 where entry = 191609;
	update quests set ReqCastSpellId1 = 51852 where entry = 12641;
	UPDATE quests SET ReqCastSpellId2=0 WHERE  entry = 12641;
	UPDATE quests SET ReqCastSpellId3=0 WHERE  entry = 12641;
	UPDATE quests SET ReqCastSpellId4=0 WHERE  entry = 12641;
	update quests set Objectives = "Use the eye of acherus and discover the Argent Battlegrounds", IncompleteText = null,ObjectiveText1 = null, ObjectiveText2 = null, ObjectiveText3 = null, ObjectiveText4 = null where entry = 	12641;
	DELETE  FROM quest_poi WHERE questId = 12641;
	DELETE  FROM quest_poi_points WHERE questId = 12641;
	REPLACE INTO quest_poi (questId,poiId,objIndex,mapId,mapAreaId,floorId,unk3,unk4) VALUES (12641,0,1,609,502,0,0,3);
	REPLACE INTO quest_poi (questId,poiId,objIndex,mapId,mapAreaId,floorId,unk3,unk4) VALUES (12641,1,-1,609,502,0,0,3);
	REPLACE INTO quest_poi_points (questId,poiId,x,y) VALUES (12641,0,2344.57,-5697.97);
	REPLACE INTO quest_poi_points (questId,poiId,x,y) VALUES (12641,1,2345.44,-5671.47);


#The Power Of Blood, Frost And Unholy (fixed text and requirements)  
	update quests set Details = "Train your spells to become a truly Deathknight", Objectives = "Talk to me after training your spells", IncompleteText = "Really?", RequiredQuest1 = 12714, flags = 65536 where entry = 12849;

#Grand theft palomino (instead, kill the horse)
	UPDATE quests SET ReqItemId1=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemId2=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemId3=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemId4=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemId5=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemId6=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemCount1=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemCount2=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemCount3=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemCount4=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemCount5=0 WHERE entry = 12680;
	UPDATE quests SET ReqItemCount6=0 WHERE entry = 12680;
	UPDATE quests SET ReqKillMobOrGOId1=0 WHERE entry = 12680;
	UPDATE quests SET ReqKillMobOrGOId2=0 WHERE entry = 12680;
	UPDATE quests SET ReqKillMobOrGOId3=0 WHERE entry = 12680;
	UPDATE quests SET ReqKillMobOrGOId4=0 WHERE entry = 12680;
	UPDATE quests SET ReqKillMobOrGOCount1=0 WHERE entry = 12680;
	UPDATE quests SET ReqKillMobOrGOCount2=0 WHERE entry = 12680;
	UPDATE quests SET ReqKillMobOrGOCount3=0 WHERE entry = 12680;
	UPDATE quests SET ReqKillMobOrGOCount4=0 WHERE entry = 12680;
	UPDATE quests SET ReqCastSpellId1=0 WHERE entry = 12680;
	UPDATE quests SET ReqCastSpellId2=0 WHERE entry = 12680;
	UPDATE quests SET ReqCastSpellId3=0 WHERE entry = 12680;
	UPDATE quests SET ReqCastSpellId4=0 WHERE entry = 12680;
	update creature_proto set spell1 = 0 where entry = 28606 or entry = 28607 or entry = 28605;
	update creature_spawns set faction = 7 where entry = 28606 or entry = 28607 or entry = 28605;
	update creature_names set killcredit1 = 28767 where entry = 28606 or entry = 28607 or entry = 28605;
	update quests set ReqKillMobOrGOId1 = 28767, ReqKillMobOrGOCount1 = 1, ObjectiveText1 = "" where entry = 12680;
	
#Into the realm of shadows (kill the dark rider)
	UPDATE quests SET ReqItemId1=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemId2=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemId3=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemId4=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemId5=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemId6=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemCount1=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemCount2=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemCount3=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemCount4=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemCount5=0 WHERE entry = 12687;
	UPDATE quests SET ReqItemCount6=0 WHERE entry = 12687;
	UPDATE quests SET ReqKillMobOrGOId1=0 WHERE entry = 12687;
	UPDATE quests SET ReqKillMobOrGOId2=0 WHERE entry = 12687;
	UPDATE quests SET ReqKillMobOrGOId3=0 WHERE entry = 12687;
	UPDATE quests SET ReqKillMobOrGOId4=0 WHERE entry = 12687;
	UPDATE quests SET ReqKillMobOrGOCount1=0 WHERE entry = 12687;
	UPDATE quests SET ReqKillMobOrGOCount2=0 WHERE entry = 12687;
	UPDATE quests SET ReqKillMobOrGOCount3=0 WHERE entry = 12687;
	UPDATE quests SET ReqKillMobOrGOCount4=0 WHERE entry = 12687;
	UPDATE quests SET ReqCastSpellId1=0 WHERE entry = 12687;
	UPDATE quests SET ReqCastSpellId2=0 WHERE entry = 12687;
	UPDATE quests SET ReqCastSpellId3=0 WHERE entry = 12687;
	UPDATE quests SET ReqCastSpellId4=0 WHERE entry = 12687;
	#fn: 28768 dark rider of achrus han de ser neutral
	#fn: 28901 caballo suelto rideable (npcflags 1677216)
	#fn: 28901 caballo suelto must have spell Horseman's call
		update creature_spawns set faction = 7 where entry = 28768 or entry = 28782;
		update creature_spawns set flags = 32768 where entry = 28782 or entry = 28901; #or entry = 28901
		update quests set ReqKillMobOrGOId1 = 28768, ReqKillMobOrGOCount1 = 1 where entry = 12687;

	
#Death's challenge (deathknight initiates are neutral, so they can talk and also are able to kill)
	UPDATE quests SET ReqItemId1=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemId2=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemId3=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemId4=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemId5=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemId6=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemCount1=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemCount2=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemCount3=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemCount4=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemCount5=0 WHERE entry = 12733;
	UPDATE quests SET ReqItemCount6=0 WHERE entry = 12733;
	UPDATE quests SET ReqKillMobOrGOId1=0 WHERE entry = 12733;
	UPDATE quests SET ReqKillMobOrGOId2=0 WHERE entry = 12733;
	UPDATE quests SET ReqKillMobOrGOId3=0 WHERE entry = 12733;
	UPDATE quests SET ReqKillMobOrGOId4=0 WHERE entry = 12733;
	UPDATE quests SET ReqKillMobOrGOCount1=0 WHERE entry = 12733;
	UPDATE quests SET ReqKillMobOrGOCount2=0 WHERE entry = 12733;
	UPDATE quests SET ReqKillMobOrGOCount3=0 WHERE entry = 12733;
	UPDATE quests SET ReqKillMobOrGOCount4=0 WHERE entry = 12733;
	UPDATE quests SET ReqCastSpellId1=0 WHERE entry = 12733;
	UPDATE quests SET ReqCastSpellId2=0 WHERE entry = 12733;
	UPDATE quests SET ReqCastSpellId3=0 WHERE entry = 12733;
	UPDATE quests SET ReqCastSpellId4=0 WHERE entry = 12733;
	#need: death knight neutral to dk but enemy to scarlets
	update creature_spawns set faction = 7, flags = 32768 where entry = 28406;
	update quests set ReqKillMobOrGoId1 = 28406, ReqKillMobOrGOCount1 = 5 where entry = 12733;

	
#The gift that keeps on giving (kill 5 miners and plant the harvest item)
	UPDATE quests SET ReqItemId1=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemId2=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemId3=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemId4=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemId5=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemId6=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemCount1=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemCount2=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemCount3=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemCount4=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemCount5=0 WHERE entry = 12698;
	UPDATE quests SET ReqItemCount6=0 WHERE entry = 12698;
	UPDATE quests SET ReqKillMobOrGOId1=0 WHERE entry = 12698;
	UPDATE quests SET ReqKillMobOrGOId2=0 WHERE entry = 12698;
	UPDATE quests SET ReqKillMobOrGOId3=0 WHERE entry = 12698;
	UPDATE quests SET ReqKillMobOrGOId4=0 WHERE entry = 12698;
	UPDATE quests SET ReqKillMobOrGOCount1=0 WHERE entry = 12698;
	UPDATE quests SET ReqKillMobOrGOCount2=0 WHERE entry = 12698;
	UPDATE quests SET ReqKillMobOrGOCount3=0 WHERE entry = 12698;
	UPDATE quests SET ReqKillMobOrGOCount4=0 WHERE entry = 12698;
	UPDATE quests SET ReqCastSpellId1=0 WHERE entry = 12698;
	UPDATE quests SET ReqCastSpellId2=0 WHERE entry = 12698;
	UPDATE quests SET ReqCastSpellId3=0 WHERE entry = 12698;
	UPDATE quests SET ReqCastSpellId4=0 WHERE entry = 12698;
	update quests set flags = 130, ReqKillMobOrGoId1 = 28819, ObjectiveText1 = "Dead miner", ReqKillMobOrGOCount1 = 5, ReqCastSpellId2 = 52481 where entry = 12698;
	DELETE  FROM quest_poi WHERE questId = 12698;
	DELETE  FROM quest_poi_points WHERE questId = 12698;
	REPLACE INTO quest_poi (questId,poiId,objIndex,mapId,mapAreaId,floorId,unk3,unk4) VALUES (12698,0,-1,609,502,0,1,3);
	REPLACE INTO quest_poi (questId,poiId,objIndex,mapId,mapAreaId,floorId,unk3,unk4) VALUES (12698,1,16,609,502,0,0,1);
	REPLACE INTO quest_poi (questId,poiId,objIndex,mapId,mapAreaId,floorId,unk3,unk4) VALUES (12698,2,13,609,502,0,0,3);
	REPLACE INTO quest_poi_points (questId,poiId,x,y) VALUES (12698,0,2349,-5758);
	REPLACE INTO quest_poi_points (questId,poiId,x,y) VALUES (12698,1,2441.98,-5918.77);
	REPLACE INTO quest_poi_points (questId,poiId,x,y) VALUES (12698,2,2441.98,-5918.77);
	
#Massacre at light's point (The mine wagons are rideable and the scarlet cannons are usable)
	UPDATE quests SET ReqItemId1=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemId2=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemId3=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemId4=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemId5=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemId6=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemCount1=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemCount2=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemCount3=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemCount4=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemCount5=0 WHERE entry = 12701;
	UPDATE quests SET ReqItemCount6=0 WHERE entry = 12701;
	UPDATE quests SET ReqKillMobOrGOId1=0 WHERE entry = 12701;
	UPDATE quests SET ReqKillMobOrGOId2=0 WHERE entry = 12701;
	UPDATE quests SET ReqKillMobOrGOId3=0 WHERE entry = 12701;
	UPDATE quests SET ReqKillMobOrGOId4=0 WHERE entry = 12701;
	UPDATE quests SET ReqKillMobOrGOCount1=0 WHERE entry = 12701;
	UPDATE quests SET ReqKillMobOrGOCount2=0 WHERE entry = 12701;
	UPDATE quests SET ReqKillMobOrGOCount3=0 WHERE entry = 12701;
	UPDATE quests SET ReqKillMobOrGOCount4=0 WHERE entry = 12701;
	UPDATE quests SET ReqCastSpellId1=0 WHERE entry = 12701;
	UPDATE quests SET ReqCastSpellId2=0 WHERE entry = 12701;
	UPDATE quests SET ReqCastSpellId3=0 WHERE entry = 12701;
	UPDATE quests SET ReqCastSpellId4=0 WHERE entry = 12701;
		update creature_spawns set faction = 2095 where entry = 28856 or entry = 28834 or entry = 28850;
		update creature_proto set npcflags = 0, spell1 = 45472, bounding_radius = 0.372,  scale = 1, armor= 9000,walk_speed = 2.5, run_speed = 8, fly_speed = 14 ,vehicleID = 117 where entry = 28821;
		update creature_spawns set flags = 1048832, faction = 2096, bytes0 = 1677472, bytes1 = 0, bytes2 = 1 where entry = 28821;
		update creature_names set type = 6, info_str = 'vehichleCursor', unknown_float1 = 10, unknown_float2 = 1 where entry = 28821;
		update quests set flags = 2, ReqKillMobOrGOId1 = 28834, ReqKillMobOrGOCount1 = 10 where entry = 12701;
		update creature_spawns set faction = 2084,movetype = 4 where id = 119001 or id = 119002 or id = 119003 or id = 119004 or id = 119005 or id = 119006 or id = 119007 or id = 119008;
		update creature_proto set npcflags = 16777216,walk_speed = 0, run_speed = 0, fly_speed = 0, spell5 = 0, rooted = 1 where entry = 28833;
		DELETE  FROM quest_poi WHERE questId = 12701;
		DELETE  FROM quest_poi_points WHERE questId = 12701;
		REPLACE INTO quest_poi (questId,poiId,objIndex,mapId,mapAreaId,floorId,unk3,unk4) VALUES (12701,0,0,609,502,0,0,3);
		REPLACE INTO quest_poi (questId,poiId,objIndex,mapId,mapAreaId,floorId,unk3,unk4) VALUES (12701,1,-1,609,502,0,0,3);
		REPLACE INTO quest_poi_points (questId,poiId,x,y) VALUES (12701,0,2270.57,-6192.97);
		REPLACE INTO quest_poi_points (questId,poiId,x,y) VALUES (12701,1,2345.44,-5671.47);

#Noth's special brew (enabled quest and enabled pot)
update gameobject_names set spellfocus = 33802, Type = 22 where entry = 190936;
update quests set ReqCastSpellId1 = 33802 where entry = 12717;
		
#Lambs to the slaughter (quest requirementson killing from the scarlet crusader proxy to 28529)
		update quests set ReqKillMobOrGOId1 = 28529 where entry = 12722;
	
#How To Win Friends And Influence Enemies (fixed objective)
		UPDATE quests SET ReqItemId1=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemId2=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemId3=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemId4=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemId5=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemId6=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemCount1=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemCount2=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemCount3=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemCount4=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemCount5=0 WHERE entry = 12720;
		UPDATE quests SET ReqItemCount6=0 WHERE entry = 12720;
		UPDATE quests SET ReqKillMobOrGOId1=0 WHERE entry = 12720;
		UPDATE quests SET ReqKillMobOrGOId2=0 WHERE entry = 12720;
		UPDATE quests SET ReqKillMobOrGOId3=0 WHERE entry = 12720;
		UPDATE quests SET ReqKillMobOrGOId4=0 WHERE entry = 12720;
		UPDATE quests SET ReqKillMobOrGOCount1=0 WHERE entry = 12720;
		UPDATE quests SET ReqKillMobOrGOCount2=0 WHERE entry = 12720;
		UPDATE quests SET ReqKillMobOrGOCount3=0 WHERE entry = 12720;
		UPDATE quests SET ReqKillMobOrGOCount4=0 WHERE entry = 12720;
		UPDATE quests SET ReqCastSpellId1=0 WHERE entry = 12720;
		UPDATE quests SET ReqCastSpellId2=0 WHERE entry = 12720;
		UPDATE quests SET ReqCastSpellId3=0 WHERE entry = 12720;
		UPDATE quests SET ReqCastSpellId4=0 WHERE entry = 12720;
		update quests set ReqKillMobOrGOId1 = 28529, ReqKillMobOrGOCount1 = 1 where entry = 12720;
		
		

#Bloody breakout (now Valroth is in front of the schedule and is killable)
REPLACE INTO creature_spawns (id, entry, map, position_x, position_y, position_z, orientation, movetype, displayid, faction, flags, bytes0, bytes1, bytes2, emote_state, npc_respawn_link, channel_spell, channel_target_sqlid, channel_target_sqlid_creature, standstate, death_state, mountdisplayid, slot1item, slot2item, slot3item, CanFly, phase) 
VALUES (119898,29011,609,1654,-6041,149.96,1.5,0,25842,2089,32768,16777472,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1);
REPLACE INTO loot_creatures (entryid, itemid, normal10percentchance, normal25percentchance, heroic10percentchance, heroic25percentchance, mincount, maxcount )
VALUES (29011, 39510, 100, 100, 100, 100, 1, 1);
update quests set ReqItemCount1 = 1, ReqItemId1 = 39510, flags = 129 where entry = 12727;


#A special surprise (for every race, every objective is killable)
	UPDATE quests SET ReqItemId1=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemId2=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemId3=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemId4=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemId5=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemId6=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemCount1=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemCount2=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemCount3=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemCount4=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemCount5=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqItemCount6=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqKillMobOrGOId1=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqKillMobOrGOId2=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqKillMobOrGOId3=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqKillMobOrGOId4=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqKillMobOrGOCount1=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqKillMobOrGOCount2=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqKillMobOrGOCount3=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqKillMobOrGOCount4=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqCastSpellId1=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqCastSpellId2=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqCastSpellId3=0 WHERE Title="A Special Surprise";
	UPDATE quests SET ReqCastSpellId4=0 WHERE Title="A Special Surprise";
	#fn: make killable npc = valok, malar, yazmina, goby, iggy, ellen, antoine, kug, donovan, lady
	update creature_spawns set flags = 32768 where entry = 29070 or entry = 29032 or entry = 29065 or entry = 29068 or entry = 29073 or entry = 29061 or entry = 29071 or entry = 29072 or entry = 29067 or entry = 29074;
	update quests set ReqKillMobOrGoId1 = 29032, ReqKillMobOrGOCount1 = 1 where entry = 12739;
	update quests set ReqKillMobOrGoId1 = 29061, ReqKillMobOrGOCount1 = 1 where entry = 12742;
	update quests set ReqKillMobOrGoId1 = 29065, ReqKillMobOrGOCount1 = 1 where entry = 12743;
	update quests set ReqKillMobOrGoId1 = 29067, ReqKillMobOrGOCount1 = 1 where entry = 12744;
	update quests set ReqKillMobOrGoId1 = 29068, ReqKillMobOrGOCount1 = 1 where entry = 12745;
	update quests set ReqKillMobOrGoId1 = 29070, ReqKillMobOrGOCount1 = 1 where entry = 12746;
	update quests set ReqKillMobOrGoId1 = 29074, ReqKillMobOrGOCount1 = 1 where entry = 12747;
	update quests set ReqKillMobOrGoId1 = 29072, ReqKillMobOrGOCount1 = 1 where entry = 12748;
	update quests set ReqKillMobOrGoId1 = 29073, ReqKillMobOrGOCount1 = 1 where entry = 12749;
	update quests set ReqKillMobOrGoId1 = 29071, ReqKillMobOrGOCount1 = 1 where entry = 12750;
	
	
#Ambush in the overlook (added scarlet courier killable spawns)
	#fn: change spawn id = 120693,120399,120551,120691 for scarlet courier
	update creature_spawns set displayid = 25897, entry = 29076 where id = 120693 or id = 120399 or id = 120551 or id = 120691;
	update loot_creatures set normal10percentchance = 100, normal25percentchance = 100, heroic10percentchance = 100, heroic25percentchance = 100 where itemid = 39647 or itemid = 39646;
	update quests set CastSpell = 19690 where entry = 12754;
	
#A meeting with fate (when ending "Ambush in the overlook", the "Scarlet illusion" spell is enabled)
	update creature_spawns set faction = 2096 where entry = 28553 or entry = 28556 or entry = 28554 or entry = 28552 or entry = 28550 or entry = 29078 or entry = 29077 or entry = 28549 or entry = 28555 or entry = 28551 or entry = 29080;
	update quests set CastSpell = 0 where entry = 12755;
	
#The scarlet onslaught emerges
	update quests set CastSpell = 54089 where entry = 12756;
	
	
#The scarlet apocalypse
	#need: change lich king finisher from 29110 to 25462
	update  creature_quest_starter set  id = 25462 where id = 29110;
	update creature_quest_finisher set  id = 25462 where id = 29110;
	
	
#And end of all things (objectives fixed)
	UPDATE quests SET ReqItemId1=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemId2=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemId3=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemId4=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemId5=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemId6=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemCount1=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemCount2=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemCount3=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemCount4=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemCount5=0 WHERE entry = 12779;
	UPDATE quests SET ReqItemCount6=0 WHERE entry = 12779;
	UPDATE quests SET ReqKillMobOrGOId1=0 WHERE entry = 12779;
	UPDATE quests SET ReqKillMobOrGOId2=0 WHERE entry = 12779;
	UPDATE quests SET ReqKillMobOrGOId3=0 WHERE entry = 12779;
	UPDATE quests SET ReqKillMobOrGOId4=0 WHERE entry = 12779;
	UPDATE quests SET ReqKillMobOrGOCount1=0 WHERE entry = 12779;
	UPDATE quests SET ReqKillMobOrGOCount2=0 WHERE entry = 12779;
	UPDATE quests SET ReqKillMobOrGOCount3=0 WHERE entry = 12779;
	UPDATE quests SET ReqKillMobOrGOCount4=0 WHERE entry = 12779;
	UPDATE quests SET ReqCastSpellId1=0 WHERE entry = 12779;
	UPDATE quests SET ReqCastSpellId2=0 WHERE entry = 12779;
	UPDATE quests SET ReqCastSpellId3=0 WHERE entry = 12779;
	UPDATE quests SET ReqCastSpellId4=0 WHERE entry = 12779;
	#fn: creature frostbrood vanquisher faction to deathknights
	#fn: devour humanoid repair?
	#fn: quest conditions on kill 150 scarlet crusader and 10 ballistas
	update quests set flags = 136, ReqCastSpellId1 = 53173 where entry = 12779;
	update creature_proto set faction = 2084, spell4 = 46453, spell5 = 0,spell6 = 0   where entry = 28670;
	#info: proxies scarlet soldiers = 29150 o 28763
	
#The lich king's command
	#need: lich king starter from 29110 to 25462

#The light of dawn (added waypoints on the nonmoving spawns so that there is a constant skirmish, the objectives are killing the 3 noobie objectives)
	UPDATE quests SET ReqItemId1=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemId2=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemId3=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemId4=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemId5=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemId6=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemCount1=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemCount2=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemCount3=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemCount4=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemCount5=0 WHERE entry = 12801;
	UPDATE quests SET ReqItemCount6=0 WHERE entry = 12801;
	UPDATE quests SET ReqKillMobOrGOId1=0 WHERE entry = 12801;
	UPDATE quests SET ReqKillMobOrGOId2=0 WHERE entry = 12801;
	UPDATE quests SET ReqKillMobOrGOId3=0 WHERE entry = 12801;
	UPDATE quests SET ReqKillMobOrGOId4=0 WHERE entry = 12801;
	UPDATE quests SET ReqKillMobOrGOCount1=0 WHERE entry = 12801;
	UPDATE quests SET ReqKillMobOrGOCount2=0 WHERE entry = 12801;
	UPDATE quests SET ReqKillMobOrGOCount3=0 WHERE entry = 12801;
	UPDATE quests SET ReqKillMobOrGOCount4=0 WHERE entry = 12801;
	UPDATE quests SET ReqCastSpellId1=0 WHERE entry = 12801;
	UPDATE quests SET ReqCastSpellId2=0 WHERE entry = 12801;
	UPDATE quests SET ReqCastSpellId3=0 WHERE entry = 12801;
	UPDATE quests SET ReqCastSpellId4=0 WHERE entry = 12801;
	#fn: quest conditions - kill 1 important guy
		#fn: modify tirion power
		#fn: modify korfax power
		#fn: modify zverenhoff power
		#fn: modify leonid power
		#fn: modify those nears respawntimes
		#fn: condition kill tirion
		#condition kill 3 defenders 29174
		update quests set ReqKillMobOrGoId1 = 29174, ReqKillMobOrGOCount1 = 3 where entry = 12801;

		

REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (121083, 1, 2401.07,-5156.4,83.34, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (121083, 2, 2434.75,-5175.6,78.29, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (121083, 3, 2397.28,-5193.93,73.62, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (121083, 4, 2363.14,-5202.91,77.864, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (121083, 5, 2329.02,-5213.74,83.88, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (121083, 6, 2298.64,-5231.68,84.44, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (121083, 7, 2287.49, -5268.51, 81.79, 2000, 0, 0, 0, 0, 0, 0, 0);

REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120925, 1, 2401.07,-5156.4,83.34, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120925, 2, 2434.75,-5175.6,78.29, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120925, 3, 2397.28,-5193.93,73.62, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120925, 4, 2363.14,-5202.91,77.864, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120925, 5, 2329.02,-5213.74,83.88, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120925, 6, 2298.64,-5231.68,84.44, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120925, 7, 2287.49, -5268.51, 81.79, 2000, 0, 0, 0, 0, 0, 0, 0);

REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120926, 1, 2401.07,-5156.4,83.34, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120926, 2, 2434.75,-5175.6,78.29, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120926, 3, 2397.28,-5193.93,73.62, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120926, 4, 2363.14,-5202.91,77.864, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120926, 5, 2329.02,-5213.74,83.88, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120926, 6, 2298.64,-5231.68,84.44, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (120926, 7, 2287.49, -5268.51, 81.79, 2000, 0, 0, 0, 0, 0, 0, 0);

REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140073, 1, 2401.07,-5156.4,83.34, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140073, 2, 2434.75,-5175.6,78.29, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140073, 3, 2397.28,-5193.93,73.62, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140073, 4, 2363.14,-5202.91,77.864, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140073, 5, 2329.02,-5213.74,83.88, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140073, 6, 2298.64,-5231.68,84.44, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140073, 7, 2287.49, -5268.51, 81.79, 2000, 0, 0, 0, 0, 0, 0, 0);

REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140074, 1, 2401.07,-5156.4,83.34, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140074, 2, 2434.75,-5175.6,78.29, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140074, 3, 2397.28,-5193.93,73.62, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140074, 4, 2363.14,-5202.91,77.864, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140074, 5, 2329.02,-5213.74,83.88, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140074, 6, 2298.64,-5231.68,84.44, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140074, 7, 2287.49, -5268.51, 81.79, 2000, 0, 0, 0, 0, 0, 0, 0);

REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140075, 1, 2401.07,-5156.4,83.34, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140075, 2, 2434.75,-5175.6,78.29, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140075, 3, 2397.28,-5193.93,73.62, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140075, 4, 2363.14,-5202.91,77.864, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140075, 5, 2329.02,-5213.74,83.88, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140075, 6, 2298.64,-5231.68,84.44, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140075, 7, 2287.49, -5268.51, 81.79, 2000, 0, 0, 0, 0, 0, 0, 0);

REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140076, 1, 2401.07,-5156.4,83.34, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140076, 2, 2434.75,-5175.6,78.29, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140076, 3, 2397.28,-5193.93,73.62, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140076, 4, 2363.14,-5202.91,77.864, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140076, 5, 2329.02,-5213.74,83.88, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140076, 6, 2298.64,-5231.68,84.44, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140076, 7, 2287.49, -5268.51, 81.79, 2000, 0, 0, 0, 0, 0, 0, 0);

REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140077, 1, 2401.07,-5156.4,83.34, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140077, 2, 2434.75,-5175.6,78.29, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140077, 3, 2397.28,-5193.93,73.62, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140077, 4, 2363.14,-5202.91,77.864, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140077, 5, 2329.02,-5213.74,83.88, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140077, 6, 2298.64,-5231.68,84.44, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140077, 7, 2287.49, -5268.51, 81.79, 2000, 0, 0, 0, 0, 0, 0, 0);

REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140078, 1, 2401.07,-5156.4,83.34, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140078, 2, 2434.75,-5175.6,78.29, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140078, 3, 2397.28,-5193.93,73.62, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140078, 4, 2363.14,-5202.91,77.864, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140078, 5, 2329.02,-5213.74,83.88, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140078, 6, 2298.64,-5231.68,84.44, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140078, 7, 2287.49, -5268.51, 81.79, 2000, 0, 0, 0, 0, 0, 0, 0);

REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140079, 1, 2401.07,-5156.4,83.34, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140079, 2, 2434.75,-5175.6,78.29, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140079, 3, 2397.28,-5193.93,73.62, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140079, 4, 2363.14,-5202.91,77.864, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140079, 5, 2329.02,-5213.74,83.88, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140079, 6, 2298.64,-5231.68,84.44, 2000, 0, 0, 0, 0, 0, 0, 0);
REPLACE INTO creature_waypoints (spawnid, waypointid, position_x, position_y, position_z, waittime, flags, forwardemoteoneshot, forwardemoteid, backwardemoteoneshot, backwardemoteid, forwardskinid, backwardskinid)
VALUES (140079, 7, 2287.49, -5268.51, 81.79, 2000, 0, 0, 0, 0, 0, 0, 0);

update creature_spawns set movetype = 2 where id = 140079 or id = 140079  or id = 140079 or id = 140079 or id = 140079 or id = 140079 or id = 140079 or id = 120926 or id = 120925 or id =121083;
update creature_names set waypointid = 0 where entry = 29190 or entry = 29190 or entry = 29219;




#Taking back acherus (Corrected castspell to the real world acherus)
	#fn: quest_ender to highlord darion mograine
	#fn: cast al final: 53822
	update quests set CastSpell = 53822 where entry = 13165;
	update creature_quest_finisher set id = 28444 where quest = 13165;


	
####################################################################### FIXED SPAWNS

	update creature_spawns set phase = 1 where phase <> 1 
		and id <> 102990 and id <> 120737
		and id <> 116748 
		and id <> 119755 and id <> 120734
		and id <> 120735
		and id <> 117380
		and id <> 119564
		and id <> 118225
		and id <> 119698 and id <> 119703 and id <> 119697
		and id <> 117380
		and id <> 119550 and id <> 119548
		and id <> 140861
		and id <> 119551
		and id <> 119552
		and id <> 119547
		and id <> 150018
		and id <> 118197
		and id <> 118219
		and id <> 118234
		and id <> 118221
		and id <> 118238
		and id <> 126906
		and id <> 119756
		and id <> 119549
		and id <> 120541
		and id <> 120414
		and id <> 120398
		and id <> 120692
		and id <> 121159
		and entry <> 28542 
		and entry <> 28405
		and entry <> 28383
		and entry <> 28500
		and entry <> 29205
		and entry <> 29208
		and entry <> 29501
		and entry <> 29207
		and entry <> 29203
		and entry <> 28491
		and entry <> 28471
		and entry <> 28489
		and entry <> 28482
		and entry <> 28490
		and entry <> 28488
		and entry <> 28474	
		and entry <> 28768
		and entry < 43300
		and entry > 26039
		;
		update creature_spawns set phase = 2 where id = 116988 or id = 116988 or id = 117467;
			
			
		update gameobject_spawns set phase = 1  where phase <> 1
		and entry <> 191747
		and entry <> 191158
		and entry <> 191503
		and entry <> 106318
		and entry <> 2843
		and id <> 46049
		and id <> 46483
		and id <> 46028
		and id <> 53225
		and id <> 46482
		;
		
	
####################################################################### OTHER FIXES

#Fix portals
	update gameobject_spawns set faction = 1732 where entry = 193053;
	update gameobject_names set spellfocus = 17334 where entry = 193053;
	update gameobject_spawns set faction = 1735 where entry = 193052;
	update gameobject_names set spellfocus = 17609 where entry = 193052;
	
#Fix spawns factions
	update creature_spawns set faction = 2084 where faction = 2085 or faction = 2082 or faction = 2100 or faction = 2050;

	#npc bad duplicates fix
	#replaced valanar for the good valanar
	update creature_quest_finisher set id = 28377 where id = 28907;
	update creature_quest_starter set id = 28377 where id = 28907;
	
####################################################################GENERAL FIXES AFTER NPCAPPEAR

	#!scourge gryphons fixed!
	update creature_proto set npcflags = 8193 where entry= 29501;
	update creature_proto set faction = 2100 where entry= 29501 or entry = 29488 or entry = 28906 or entry = 28864;

	#scarlet marksman attackable
	update creature_spawns set flags = 32768 where entry = 28610;
	
	
	
	#dead mad attackers fix  
	update creature_spawns set flags = 16384, standstate = 0, death_state = 2 where 
	entry = 28942 
	or entry = 28940 
	or entry = 28610 
	or entry = 28939 
	or entry = 28941 
	and bytes1 = 7
	;
	
	update creature_proto set npcflags = 0 where 
	entry = 28942 
	or entry = 28940 
	or entry = 28610 
	or entry = 28939 
	or entry = 28941 
	;
	update creature_names set flags1 = 0 where 
	entry = 28942 
	or entry = 28940 
	or entry = 28610 
	or entry = 28939 
	or entry = 28941 
	;
	#shadowny warriors neutral
	update creature_spawns set faction = 7 where entry = 28769;
	
####################################################################ADD RESPAWNTIME ON UNRESPAWNABLE CREATURES
	update creature_proto p
	inner join creature_spawns s on
		p.entry = s.entry
	set p.respawntime = 180000
	where s.entry > 26039 and s.entry < 43300 and p.respawntime = 0;

	
####################################################################
	

	#fn: disable autoaccept quests
	update quests set flags = flags-524288 where flags >= 524288;

	#fn: hearthglen by ghouls
	update creature_spawns set entry = 29136, displayid = 24997,faction = 2100 where entry = 29102 and map = 609;

########################################################################################################################################

###UNDEAD CHAIN
#Warlocks must not start with spell imp (Quest Piercing the veil gives the spell)
DELETE FROM playercreateinfo_spells WHERE spellid = 688 and indexid = 38;
DELETE FROM playercreateinfo_spells WHERE spellid = 688 and indexid = 39;
DELETE FROM playercreateinfo_spells WHERE spellid = 688 and indexid = 40;
DELETE FROM playercreateinfo_spells WHERE spellid = 688 and indexid = 41;
DELETE FROM playercreateinfo_spells WHERE spellid = 688 and indexid = 55;
#nd:quest Marla's Last wish poi
#npc "Deathguard dillinger" & "Deathguard burgess" are a quest giver but doesn't give quest
update creature_names set info_str = "Directions" where entry = 1746 or entry = 1496;
update creature_proto set npcflags = 268435457, faction = 71 where entry = 1496 or entry = 1652;
update creature_spawns set flags = 32768, faction = 71, bytes2 = 69633 where entry = 1496 or entry = 1652;


##BLOOD ELF CHAIN
#:falta npc "aldaron the reckless" (spawn existe, cambiar displayid de 15925 a 15513?)
update creature_spawns set movetype = 0, bytes1 = 8 where entry = 16294;
update creature_names set male_displayid = 15513, unknown_float2 = 1 where entry = 16294;
DELETE FROM creature_waypoints where spawnid = 65185;

###TAUREN CHAIN
#:quest "attack on camp narache" duplicated
DELETE FROM gameobject_quest_starter where quest = 24857;
DELETE FROM creature_quest_finisher where quest = 24857;
#need:spell "war stomp" don't work
#:quest "kyle's gone missing" don't work
update quests set ReqKillMobOrGOId2 = 0, ReqKillMobOrGOCount2 = 0, ReqItemId1 = 33009, ReqItemCount1 = 1 where entry = 11129;
#need:spell "lightning shield" gives double xp per kill when it is activated when killing enemies

###ORC CHAIN
#:quest from flawer power stone has no text
update quests set Details = "Maybe these stones will be useful on the future..." where entry = 926;
#:quest "admiral's orders" given from aged envelope but should not appear
update quests set ReqItemId2 = 4881, ReqItemCount2 = 1 where entry = 830;


###DRAENEI CHAIN
#n:quest "urgent delivery" not activated
#n:quest "rescue the survivors!" not activated
#n:quest "spare parts" not activated
#n:quest "inoculation" not activated
#n:quest "botanist taerix" not activated
#n:quest "paladin training" useless
update quests set RequiredQuest1 = 9280 where  entry = 9409 or entry = 9283 or entry = 9305 or entry = 9303 or entry = 9371 ;
#quest "red snapper- very tasty" mob doens't work
update quests set ReqItemId1=0,ReqItemCount1=0,ReqKillMobOrGOId1=-181616,ReqKillMobOrGOCount1=10,ReqCastSpellId1=29866 where entry = 9452;
#npc "echarch menelaus" doesnt interact to quest
update creature_proto set npcflags = 2 where entry = 17116;
#npc "admiral odeslius" doesnt interact to quest
update creature_proto set npcflags = 2 where entry = 17240;
#quest "tree's company" don't work
update quests set ReqCastSpellId1 = 30298 where entry = 9531;
update creature_spawns set position_x = -5080, position_y = -11255, flags = 0, bytes0 = 16777472, bytes2 = 1 where entry = 17243; 
#: modify waypoints because the engineer spark goes out //'17243'
DELETE FROM creature_waypoints where spawnid = 71860;

###HUMAN QUEST CHAIN
#erase duplicated chests (done, doent consider it in taking out the phases)
#:in human quest chain ,some creatures must have hostile factions (thugs, garrick)
update creature_proto set faction = 17 where entry = 38 or entry = 103;
update creature_proto set faction = 26 where entry = 257;
update creature_spawns set faction = 17 where entry = 38 or entry = 103;
update creature_spawns set faction = 26 where entry = 257;

###ELF QUEST CHAIN
#rageclaw quest
update quests set ReqKillMobOrGOId1 = 7318,ReqKillMobOrGOCount1 = 1 where entry = 2561;

###DWARF QUEST CHAIN 
#quest init hunter
update creature_quest_starter set id = 11807 where quest = 6075;
#need: eyes of the beast doesn't work




########################################################################################################################################
####INFO FACTIONS
#1878 - friend to friendly npcs (35) - enemy to you
#35 - frendly npcs (atm horde)