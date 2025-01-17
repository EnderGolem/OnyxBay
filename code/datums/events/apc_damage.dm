/datum/event/apc_damage
	id = "apc_damage"
	name = "APC Damage"
	description = "Random APC will get damaged"

	mtth = 1 HOURS

	var/apcSelectionRange	= 25

/datum/event/apc_damage/get_mtth()
	. = ..()
	. -= (SSevents.triggers.roles_count["Engineer"] * (12 MINUTES))
	. = max(1 HOUR, .)

/datum/event/apc_damage/on_fire()
	var/obj/machinery/power/apc/A = acquire_random_apc()
	var/severity_range = pick(0, 7, 15)

	for(var/obj/machinery/power/apc/apc in range(severity_range, A))
		if(is_valid_apc(apc))
			apc.emagged = 1
			apc.update_icon()

/datum/event/apc_damage/proc/acquire_random_apc()
	var/list/possibleEpicentres = list()
	var/list/apcs = list()

	for(var/obj/effect/landmark/newEpicentre in GLOB.landmarks_list)
		if(newEpicentre.name == "lightsout")
			possibleEpicentres += newEpicentre

	if(!possibleEpicentres.len)
		return

	var/epicentre = pick(possibleEpicentres)
	for(var/obj/machinery/power/apc/apc in range(epicentre, apcSelectionRange))
		if(is_valid_apc(apc))
			apcs += apc
			// Greatly increase the chance for APCs in maintenance areas to be selected
			var/area/A = get_area(apc)
			if(istype(A,/area/maintenance))
				apcs += apc
				apcs += apc

	return safepick(apcs)

/datum/event/apc_damage/proc/is_valid_apc(obj/machinery/power/apc/apc)
	var/turf/T = get_turf(apc)
	return !apc.is_critical && !apc.emagged && T && (T.z in GLOB.using_map.get_levels_with_trait(ZTRAIT_STATION))
