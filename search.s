#Lab 6 search.s file. Created by: Nicholas Trambitas 

#BY SUBMITTING THIS FILE AS PART OF MY LAB ASSIGNMENT, I CERTIFY THAT
#ALL OF MY CODE FOUND WITHIN THIS FILE WAS CREATED BY ME WITH NO
#ASSISTANCE FROM ANY PERSON OTHER THAN THE INSTRUCTOR OF THIS COURSE
#OR ONE OF OUR UNDERGRADUATE GRADERS. I WROTE THIS CODE BY HAND,
#IT IS NOT MACHINE GENERATED OR TAKEN FROM MACHINE GENERATED CODE.

.file "search.s" 	#optional directive
.section .rodata 	#required directive for rodata

print_result:
.string "\nSearch selected frame %ld with %d zero-crossings \n"

.data				#required for file scope data: read-write 
					#of static storage class program data


.globl search		#required directive for every function
		
		.type search, @function 		#required directive
.text

#required directive - code begins here
search:

			pushq %rbp		#stack housekeeping #1

			movq %rsp, %rbp	#stack housekeeping #2
			#rdi holds the array of frames
			#rsi holds the count (num of frames in the array)
			
			pushq %rbx #use callee saved register to save the array of frames to rbx
			movq %rdi, %rbx	#Needed to survive a function call

			pushq %r12 #push callee saved register to stack. Needed to be able to survive a functionn call
			movq %rsi, %r12 #r12 now holds the number of frames in the array

			pushq %r13 #push callee saved register to stack so it survives function call
					   #r13 will be used to hold the greatest ZC count

	    	pushq %r14 #push callee saved register to stack so it survives a function call
					   #r14 holds the return address for the frame with the greatest zc
		
		    pushq %r15 #push callee saved register to stack so it survives a function call
					   #r15 holds the index count for the loop
            xorq %r15, %r15 #temporary storage for calulated struct address

loop_start:
		#set up loop that will iterate through each struct of the array. Jump to end of loop when end of array is reached
			movq $1, %rdi
			cmpq %rdi, %r12
			jl  loop_leave #jump when r12 > 1

			dec %r12 #decrement the number of elements to search
			#compute the address for the "r12"th element in the array
			imulq $152, %r12, %rax #multiply counter by offset 152. Effectivly, you are selecting the correct struct in the array
			leaq (%rbx, %rax), %rdi #calculate the address of the frame struct and store it in rdi
			movq %rdi, %r15	#we want to save this calculated address in case we need to save it again after the function call
			
			call evaluate #call evaluate with the address of the frame pointer. We expect to get a zc count in return

			movswq %ax, %rdi #rdi now holds the count that analyze returned
			
			cmpq %r13, %rdi #sets the flags for conditional moves
			cmovg %rdi, %r13 #move only if count returned from evaluate is > current count in r13
			cmovg %r15, %r14 #move new frame with highest zc based on update/conditions above checked

		
			jmp loop_start


loop_leave:
			
	xorq %rax, %rax #clear rax for preperation of print call
	movq $print_result, %rdi #set rdi to hold the format string. Will be 1st param for print call
	movq (%r14), %rsi #go to memory and get the frame id from the struct and store it to rsi for 2nd param in print call
	movq %r13, %rdx  #move the num of zc to rdx. 3rd param for print call
	
	call print
	
	movq %r14, %rax #move address of best frame to rax for ret 
	
	#restore all caller saved registers
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbx

			leave 			#return stack to original values

			ret				#return
				.size search, .-search	#required directive
