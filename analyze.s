#Lab 6 analyze.s file. Created by: Nicholas Trambitas 

#BY SUBMITTING THIS FILE AS PART OF MY LAB ASSIGNMENT, I CERTIFY THAT
#ALL OF MY CODE FOUND WITHIN THIS FILE WAS CREATED BY ME WITH NO
#ASSISTANCE FROM ANY PERSON OTHER THAN THE INSTRUCTOR OF THIS COURSE
#OR ONE OF OUR UNDERGRADUATE GRADERS. I WROTE THIS CODE BY HAND,
#IT IS NOT MACHINE GENERATED OR TAKEN FROM MACHINE GENERATED CODE.

.file "analyze.s" 	#optional directive
.section .rodata 	#required directive for rodata

.data				#required for file scope data: read-write 
					#of static storage class program data


.globl analyze		#required directive for every function
		
		.type analyze, @function 		#required directive
.text

#required directive - code begins here
analyze:

			pushq %rbp		#stack housekeeping #1

			movq %rsp, %rbp	#stack housekeeping #2
			
			xorq %rsi, %rsi #clear register that will hold array index
			xorq %rdx, %rdx #clear register that will hold value at index
			xorq %rcx, %rcx #clear register to 0, used to hold value of previous element of array
			xorw %ax, %ax	#set ax to 0. Will hold the number of 0 crossings.
			movq $64, %r8   #r8 to hold the size/length of the array	
			xorq %r9, %r9   #r9 holds the energy of the frame (sum of all samples squared)
			xorq %r10, %r10 #clear r10. Will be used as a scratchpad for calculating the amplitude squared

loop_start:
		#set up loop that will iterate through each element of the array of size 64. Jump to end of loop when end of array is reached
			cmp %r8, %rsi
			jge loop_leave

		#go to the struct and access the element in array at index in rsi. Store result in rdx
			movswq 24(%rdi, %rsi, 2), %rdx
			movq %rdx, %r10  #copy the value read from the array and store it in r10 
			imulq %r10, %r10  #square the sample and store it in r10
			addq %r10, %r9		   #add the squared amplitude of sample to r9. r9 holds the total energy
			

			#check if sign is different than previous sample. This will indicate if we should increment numOfCrossings
			xorq %rdx, %rcx
			js increment_crossing  #with xorq, sign bit gets set to 1 only if the values have different signs. 
								   #increment numOfCrossings when this happens
			jmp loop_end


increment_crossing:
			inc %ax #increment the number of crossings
			jmp loop_end


loop_end:	
			movq %rdx, %rcx	#copy current value in rdx as the previous element of array in rcx
			inc %rsi		#increment index to next pos in array
			jmp loop_start


loop_leave:
			
	movw %ax, 8(%rdi)#move result of rax to memory and call it a day:)
	movq %r9, 16(%rdi)#move computed energy to memory

			leave 			#return stack to original values

			ret				#return
				.size analyze, .-analyze	#required directive
