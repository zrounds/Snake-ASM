.text 0x0000		

	add $0, $0, $0 # nop
initialize:
	addi $t0, $0, 0 #Charcode 
	addi $t1, $0, 0 #i
	addi $t2, $0, 1200 #loop upper limit
initialLoop:
	sw $t0, 0x4000($t1) #write charcode to current screenpos
	addi $t1, $t1, 1 #incrememnt screen pos
	bne $t1, $t2, initialLoop #loop until i = 1200
initialSnakePosition:
	addi $t7, $0, 3 # 3 Snake pieces to begin 
	addi $t9, $0, 3
	sw $0, 0x2000($0)# dmem is then initialized to start snake in top left corner, head at (0,2)
	sw $0, 0x2002($0)
	sw $0, 0x2004($0)
	sw $0, 0x2005($0)
	addi $t0, $0, 1
	sw $t0, 0x2003($0)
	addi $t0, $0, 2
	sw $t0, 0x2001($0)
	#initial snake position drawn in top left
	addi $t4, $0, 2
	sw $t4, 0x4000($0)
	sw $t4, 0x4028($0)
	sw $t4, 0x4050($0)
	addi $s7, $0, 3
	addi $s6, $0, 1
	ori $s5, $0, 0x0014
	ori $s4, $0, 0x000c
	addi $t1, $0, 812
	addi $t0, $0, 1
	sw $t0, 0x4000($t1)
	addi $t8, $0, 10
	#Initial pause at start
	addi $a0, $0, 100
	jal pause
main:
	#Take keyboard input into t5
	lw $t5, 0x6000($0)
	#Load last movement's direction into t6
	addi $t6, $s7, 0 
	#Check if t5 is any of the numpad keys being used as the direction arrows
	#If so branch to the specific case of handling that direction
checkUp: #Up is either 0x00000075 or 0x0000F075
	ori $t0, $0, 0x0075
	beq $t0, $t5, upInput
	ori $t0, $0, 0xF075
	beq $t0, $t5, upInput
checkRight: # Right is either 0x00000074 or 0x0000F074
	ori $t0, $0, 0x0074
	beq $t0, $t5, rightInput
	ori $t0, $0, 0xF074
	beq $t0, $t5, rightInput
checkDown: #Down is either 0x00000073 or 0x0000F073
	ori $t0, $0, 0x0073
	beq $t0, $t5, downInput
	ori $t0, $0, 0xF073
	beq $t0, $t5, downInput
checkLeft: #Left is either 0x0000006b or 0x0000F06b
	ori $t0, $0, 0x006b
	beq $t0, $t5, leftInput
	ori $t0, $0, 0xF06b
	beq $t0, $t5, leftInput
ElseUseLastDirection: 
	#If the input is not any of the directions, assume we continue in the same direction as before and go to continue
	addi $t5, $t6, 0
	j continue
#These are just consolidating lines because we treat key press and key release the same 
#Update t5 with the encoding of the direction input and validate it in reference to the last moved direction
upInput:
	addi $t5, $0, 1
	j validateDirection
rightInput:
	addi $t5, $0, 2
	j validateDirection
downInput:
	addi $t5, $0, 3
	j validateDirection
leftInput:
	addi $t5, $0, 4
	j validateDirection
#Branches to the specific handling of the direction we just resolved as input - makes sure that we aren't trying to do a 180
# 	and instead continues in the same direction if you try to do that (just a completely illegal move rather than 
#	a loss) 
validateDirection: 
	beq $t5, $t6, continue #no need to validate versus last moved direction if we are moving in the same direction as just before
	addi $t0, $0, 1
	beq $t0, $t6, validateUp
	addi $t0, $0, 2
	beq $t0, $t6, validateLeft
	addi $t0, $0, 3
	beq $t0, $t6, validateDown
	addi $t0, $0, 4
	beq $t0, $t6, validateRight
	#Assume that t6 must be a valid direction and we won't fall through here
	
# Each of these works the same way. Checks the current direction against the known opposite of the last movement. Jumps to continue
#	if these are not equal, otherwise sets t5 to be the last moved direction if it in fact the opposite direction
#	and then still moves to continue. 
validateUp:
	addi $t0, $0, 3
	bne $t5, $t0, continue
	addi $t5, $0, 1
	j continue
validateRight:
	addi $t0, $0, 4
	bne $t5, $t0, continue
	addi $t5, $0, 2
	j continue
validateDown:
	addi $t0, $0, 1
	bne $t5, $t0, continue
	addi $t5, $0, 3
	j continue
validateLeft:
	addi $t0, $0, 2
	bne $t5, $t0, continue
	addi $t5, $0, 4
	j continue
#At this point, t5 is the validated next move direction and we don't need to know which way was last moved. Move the current direction
#	into t6 to stick the currently reserved registers (t6, t7) together for convenience's sake. 
continue:
	addi $t6, $t5, 0 
	addi $s7, $t6, 0 #Store the current direction as the future "last moved" value in s7 register
	lw $s2, 0x2000($0) #X position of snake head
	lw $s3, 0x2001($0) #Y position of snake head
	#Go to the movement case for the current direction 
	addi $t0, $0, 1
	beq $t6, $t0, moveUp
	addi $t0, $0, 2
	beq $t6, $t0, moveRight
	addi $t0, $0, 3
	beq $t6, $t0, moveDown
	addi $t0, $0, 4
	beq $t6, $t0, moveLeft
	#Assume we don't fall off as t6 contains a validated direction (1-4) 
# X remains the same, increment Y. Place these new coordinates in S1, S2. 
moveUp:
	addi $s0, $s2, 0
	addi $s1, $s3, -1
	j updateHead
# Increment X, Y remains the same. Place these new coordinates in S1, S2. 
moveRight:
	addi $s0, $s2, 1
	addi $s1, $s3, 0
	j updateHead
# Decrement Y, X remains the same. Place these new coordinates in S1, S2. 
moveDown:
	addi $s0, $s2, 0
	addi $s1, $s3, 1
	j updateHead
# Decrement X, Y remains the same. Place these new coordinates in S1, S2. 
moveLeft:
	addi $s0, $s2, -1
	addi $s1, $s3, 0
	j updateHead
# S0, S1 contain the new coordinates of the snake's head. Update this in memory. 
# Note that s2, s3 still contain the previous location of the head.
updateHead:
	sw $s0, 0x2000($0) #Store head X
	sw $s1, 0x2001($0) #Store head Y
	addi $t5, $0, 2 #Set offset to 2
	addi $t6, $0, 1 #Start loop at i = 1 since we handled the head as a special case. We can use t6 since the head's movement
			#has already been calculated. 

# This loops through all body positions after the head, making each subsequent piece move to the location that the segment
#	in front of it previously held. 
moveLoop:
	beq $t6, $t7, checkPill #Exit loop once i = number of segments in the snake (stored in t7)
	lw $s0, 0x2000($t5) #Current X
	lw $s1, 0x2001($t5) #Current Y
	sw $s2, 0x2000($t5) #Store new X (from the previously handled segment)
	sw $s3, 0x2001($t5) #Store new Y (from the previously handled segment)
	addi $s2, $s0, 0 #Move the X that this segment just held into s2 for use in the next loop iteration 
	addi $s3, $s1, 0 #Move the Y that this segment just held into s3 for use in the next loop iteration 
	addi $t5, $t5, 2 #Increment offset by 2 (because we move up to the next (X,Y) pair in memory
	addi $t6, $t6, 1 #Increment loop counter 
	j moveLoop #Loop 
#Currently assume we erase the tail from screen mem since we cannot grow yet. s0 and s1 are the tail's x,y when the loop ends. 
checkPill:
	lw $t0, 0x2000($0)
	bne $t0, $s4, eraseTail
	lw $t0, 0x2001($0)
	bne $t0, $s5, eraseTail
	addi $t9, $t9, 1
	j makePill
eraseTail:
	sll $t0, $s3, 5 #Row << 5
	sll $t1, $s3, 3 #Row << 3
	add $t2, $t1, $t0 #(Row << 5) + (Row << 3)
	add $t3, $t2, $s2 #screenpos = (Row << 5) + (Row << 3) + Col 
	sw $0, 0x4000($t3) #Set char at screenpos to char 0 (black background) 
drawPrep:
	addi $t5, $0, 0
	addi $t6, $0, 0 
	addi $t4, $0, 2
drawLoop:
	beq $t6, $t7, checkDeath
	lw $s2, 0x2000($t5)
	lw $s3, 0x2001($t5)
	sll $t0, $s3, 5
	sll $t1, $s3, 3
	add $t2, $t1, $t0
	add $t3, $t2, $s2
	sw $t4, 0x4000($t3)
	addi $t5, $t5, 2
	addi $t6, $t6, 1
	j drawLoop
checkDeath:
	j checkGameOver
waitBeforeNextCycle:
	addi $t7, $t9, 0
	addi $a0, $t8, 0
	lw $t5, 0x6000($0)
	jal pause
	j main
gameOver:
	j gameOver
#Pause routine from Montek 
pause:
	addi	$sp,$sp,-8
	sw	$ra,4($sp)
	sw	$a0,0($sp)
	sll     $a0, $a0, 16
	beq	$a0,$0, pse_done
pse_loop:
	addi    $a0, $a0, -1
	beq	$a0, $0, pse_done
	j	pse_loop
pse_done:
	lw	$a0,0($sp)
	lw	$ra,4($sp)
	addi	$sp,$sp,8
	jr	$ra
	ori	$a0, $0, 5
makePill:
	lw $s4, 0x2400($s6)
makeY:
	lw $s5, 0x2600($s6)
	addi $s6, $s6, 1
	addi $t0, $0, 0
	addi $t1, $0, 0
checkSpaceOccupied: 
	beq $t0, $s7, allSpacesClear
	lw $t2, 0x2000($t1)
	bne $t2, $s4, spaceClear
	lw $t2, 0x2001($t1)
	beq $t2, $s5, makePill
spaceClear:
	addi $t0, $t0, 1
	addi $t1, $t1, 2
	j checkSpaceOccupied
allSpacesClear:
	sll $t0, $s5, 5 #drawPill
	sll $t1, $s5, 3
	add $t2, $t1, $t0
	add $t3, $t2, $s4
	addi $t4, $0, 1
	sw $t4, 0x4000($t3)
	addi $t0, $0, 2 #minimum speed of game
	beq $t8, $t0, eraseTail
	addi $t8, $t8, -1
	j eraseTail
checkGameOver:
	lw $t0, 0x2000($0)
	slt $t2, $t0, $0
	bne $t2, $0, gameOver
	addi $t1, $0, 40
	beq $t1, $t0, gameOver
	lw $t0, 0x2001($0)
	slt $t2, $t0, $0
	bne $t2, $0, gameOver
	addi $t1, $0, 30
	beq $t1, $t0, gameOver
	addi $t0, $0, 2
	addi $t1, $0, 1
bodyCollisionLoop:
	beq $t1, $s7, noBodyCollision
	lw $t3, 0x2000($t0)
	lw $t4, 0x2000($0)
	bne $t3, $t4, segmentClear
	lw $t3, 0x2001($t0)
	lw $t4, 0x2001($0)
	beq $t3, $t4, gameOver
segmentClear:
	addi $t0, $t0, 2
	addi $t1, $t1, 1
	j bodyCollisionLoop
noBodyCollision:
	j waitBeforeNextCycle
	