##Versione 0 per definire le cordinate
proc print_bond {args} {
	draw delete all
	global selection1
	global selection2
	set sel1 [atomselect top $selection1 ]
	draw sphere [ center_of_mass $sel1 ] radius 1
	set sel2 [atomselect top $selection2 ]
	draw sphere [ center_of_mass $sel2 ] radius 1
	draw line [ center_of_mass $sel1 ] [ center_of_mass $sel2 ] width 5
}


## bcolor
# controlla che sia definito un colore e assegna il colore agli elementi di draw
proc bcolor {} {
global bond_c
if {[info exists bond_c]} {
	draw color $bond_c
	draw materials on
	draw material AOShiny
	}
}

#color_bond
#Assegna un colore agli elementi
proc color_bond {color} {
global bond_c
set bond_c  $color
}

## Versione 1 per definire le cordinate


proc print_bond {args} {
	draw delete all
	global sele_bond1
	global sele_bond2
	bcolor
	set com_1 [measure center [atomselect top $sele_bond1 ] weight mass]
	draw sphere $com_1  radius 1.5 resolution 20
	set com_2 [measure center [atomselect top $sele_bond2 ] weight mass]
	draw sphere $com_2 radius 1.5 resolution 20
	draw line $com_1 $com_2 width 5
	set bond_l [vecdist $com_1 $com_2 ]
	#text {x y z} ``text string'' [size s] [thickness t]
	#draw text $com_2 [format "%.2f" $bond_l] size 1
}


### print_angle versione 0
proc print_angle {args} {
	draw delete all
	global sele_angle1
	global sele_angle2
	global sele_angle3
	global anglecolor
	draw color $angle_color
	set sel1 [atomselect top $sele_angle1 ]
	draw sphere [ center_of_mass $sel1 ] radius 1
	set sel2 [atomselect top $sele_angle2 ]
	draw sphere [ center_of_mass $sel2 ] radius 1
	set sel3 [atomselect top $sele_angle3 ]
	draw sphere [ center_of_mass $sel3 ] radius 1
	draw line [ center_of_mass $sel2 ] [ center_of_mass $sel3 ] width 5
	draw line [ center_of_mass $sel1 ] [ center_of_mass $sel2 ] width 5
}



###Print angle versione 1


proc print_angle {args} {
	draw delete all
	global sele_angle1
	global sele_angle2
	global sele_angle3
	bcolor
	set com_1 [measure center [atomselect top $sele_angle1 ] weight mass]
	draw sphere $com_1  radius 1.5  resolution 20
	set com_2 [measure center [atomselect top $sele_angle2 ] weight mass]
	draw sphere $com_2 radius 1.5 resolution 20
	set com_3 [measure center [atomselect top $sele_angle3 ] weight mass]
	draw sphere $com_3 radius 1.5 resolution 20
	draw line $com_1 $com_2  width 5
	draw line $com_2 $com_3 width 5
	#draw a triangle between coordinates
	draw triangle [ vecadd $com_2 [vecscale [ vecsub $com_1 $com_2] 0.8 ]] $com_2 [ vecadd $com_2 [vecscale [ vecsub $com_3 $com_2] 0.8 ] ]
	set vec1 [ vecscale [vecsub $com_1 $com_2]  [expr 1/[vecdist $com_1 $com_2] ] ]
	set vec2 [ vecscale [vecsub $com_3 $com_2]  [expr 1/[vecdist $com_3 $com_2] ] ]
	set angle_theta [expr 180*[expr acos( [vecdot $vec1 $vec2] )]/3.14 ]
	#text {x y z} ``text string'' [size s] [thickness t]
	#draw text $com_1 [format "%.2f" $angle_theta] size 1
}


###Print Dihedral version 1

proc print_dihe {args} {
	draw delete all
	global sele_dihe1
	global sele_dihe2
	global sele_dihe3
	global sele_dihe4
	bcolor
	set com_1 [measure center [atomselect top $sele_dihe1 ] weight mass]
	draw sphere $com_1  radius 1.5  resolution 20
	set com_2 [measure center [atomselect top $sele_dihe2 ] weight mass]
	draw sphere $com_2 radius 1.5 resolution 20
	set com_3 [measure center [atomselect top $sele_dihe3 ] weight mass]
	draw sphere $com_3 radius 1.5 resolution 20
	set com_4 [measure center [atomselect top $sele_dihe4 ] weight mass]
	draw sphere $com_4 radius 1.5 resolution 20
	draw line $com_1 $com_2  width 5
	draw line $com_2 $com_3 width 5
	draw line $com_3 $com_4 width 5

	#draw a triangle between coordinates
	set angle_vis 0.5
	draw triangle [ vecadd $com_3 [vecscale [ vecsub $com_2 $com_4] $angle_vis ]] $com_3 [ vecadd $com_3 [vecscale [ vecsub $com_4 $com_3] $angle_vis ] ]

	#Calcolo valore diedrale da aggiornare
	#set vec1 [ vecscale [vecsub $com_1 $com_2]  [expr 1/[vecdist $com_1 $com_2] ] ]
	#set vec2 [ vecscale [vecsub $com_3 $com_2]  [expr 1/[vecdist $com_3 $com_2] ] ]
	#set angle_theta [expr 180*[expr acos( [vecdot $vec1 $vec2] )]/3.14 ]
	#text {x y z} ``text string'' [size s] [thickness t]
	#draw text $com_1 [format "%.2f" $angle_theta] size 1
}








####set angle [expr acos([vecdot {1 0 0} {0 1 0}])]###

proc start_bond { sele1 sele2 } {
global sele_bond1
global sele_bond2
global vmd_frame
set sele_bond1 $sele1
set sele_bond2 $sele2
# set a trace to detect when an animation frame changes
print_bond
trace variable vmd_frame([molinfo top]) w print_bond
}

proc start_angle { sele1 sele2 sele3 } {
global sele_angle1
global sele_angle2
global sele_angle3
global vmd_frame
set sele_angle1 $sele1
set sele_angle2 $sele2
set sele_angle3 $sele3
# set a trace to detect when an animation frame changes
print_angle
trace variable vmd_frame([molinfo top]) w print_angle
}




proc start_dihe { sele1 sele2 sele3 } {
global sele_dihe1
global sele_dihe2
global sele_dihe3
global sele_dihe4
global vmd_frame
set sele_dihe1 $sele1
set sele_dihe2 $sele2
set sele_dihe3 $sele3
set sele_dihe4 $sele4
# set a trace to detect when an animation frame changes
print_dihe
trace variable vmd_frame([molinfo top]) w print_angle
}

proc stop_bond {} {
draw delete all
global vmd_frame
trace vdelete vmd_frame([molinfo top]) w print_bond
}


proc stop_angle {} {
draw delete all
global vmd_frame
trace vdelete vmd_frame([molinfo top]) w print_angle
}


proc stop_dihe {} {
draw delete all
global vmd_frame
trace vdelete vmd_frame([molinfo top]) w print_dihe
}




###example to print a bond
###start_bond "protein and name CA" "resid 580 to 590 and name CA"

### example to print an Angle
###start_angle "protein and name CA" "resid 596 to 598 and name CA" "resid 604 to 606 and name CA"
