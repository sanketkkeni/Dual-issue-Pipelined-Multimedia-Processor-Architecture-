module fetch(clk,incrpc);

input logic clk, incrpc; 
logic [0:14] pc;
logic [0:63] twoinstructions;
logic [0:7] cache [256];
logic stall_frominstrpair, strhazard, strhazard1, Finish, Finish1, Finish2, Finish3, Finish4, Finish5, Finish6, Finish7, Finish8;
logic stall,delaypipe, delaypipe1, stall_onlyone, stall1, stall2;
logic instr1_is_even, instr2_is_even, flush, flush_3c, flush_3c1, flush_3c2, flush_3c3;
logic instr1_is_even1, instr2_is_even1, instr1_is_even2, instr2_is_even2, waw_hazard, waw_hazard1, waw_hazard2, waw_hazatff;
logic [0:31] instruction1_issue, instruction2_issue, instruction1_issue1, instruction2_issue1;
logic addr_match1, addr_match2, addr_match3, addr_match4, addr_match5, addr_match6, addr_match7, addr_match8;

logic [0:31] instructionsave, instruction_decode1, instruction_decode2, instruction_decode_delay1, instruction_decode_delay2;
logic [0:6] addr_ra, addr_ra_o, addr_rb, addr_rb_o, addr_rc, addr_rc_o, addr_rt, addr_rt_o;
logic [0:6] addr_rt1,addr_rt2,addr_rt3,addr_rt4,addr_rt5,addr_rt6,addr_rt7,addr_rt8,addr_rt9;
logic [0:6] addr_rt1_o,addr_rt2_o,addr_rt3_o,addr_rt4_o,addr_rt5_o,addr_rt6_o,addr_rt7_o,addr_rt8_o,addr_rt9_o;
logic [0:31] instruction_RegFetch_e, instruction_RegFetch_o, br_add, br_add1, br_add2, br_add3;
logic [0:19] count_latency,latency_counttt, latency_counttt_o, stall_for_cycles, stall_for_cycles1, stall_for_cycles2;
logic br_taken, br_taken1, br_taken2, br_taken3, br_taken4, br_taken5, br_taken6, br_taken7;
logic br_first, br_first1, br_first2, br_first3, br_first4, br_first5;
logic flush_for4cycles, flush_for4cycles1, flush_for4cycles2, flush_for4cycles3, flush_for4cycles4, flush_for4cycles5, flush_for4cycles6, flush_for4cycles7; 



logic signed [0:127] ra, rb, rc, ra_o, rb_o, rc_o;
logic signed [0:127] reg1 [128];
logic wr_en, wr_en1,wr_en2, wr_en3, wr_en4, wr_en5, wr_en6,wr_en7, wr_en8;

logic [0:31] instruction; 
logic [0:15]halfwordextend;
logic [0:31] wordextend, tempword;
logic [0:32] temp;
logic [0:127] count;
logic [0:7] count1, byte1;
logic [0:31] a,b,t;
real q,w,e,temp1, mag;
logic [0:3] UnitID,  pipe_count_SF1, pipe_count_Byte, UnitID2, UnitID3, UnitID4, UnitID5, UnitID6, UnitID7;
logic [0:31] PC;
logic signed [0:127] rt;
logic signed [0:127] temp_rt;
logic signed [0:142] rt1, rt2, rt3, rt4, rt5, rt6, rt7, rt1_SF1, rt1_SF2, rt1_SP1, rt1_SP2, rt1_Byte;
logic signed [0:142] rt2_Byte, rt3_Byte, rt2_SF2, rt3_SF2, rt2_SP1, rt3_SP1, rt4_SP1, rt5_SP1, rt2_SP2, rt3_SP2, rt4_SP2, rt5_SP2, rt6_SP2;
logic signed [0:142] FW_rt1, FW_rt2, FW_rt3, FW_rt4, FW_rt5, FW_rt6, FW_rt7, FW_rt8;
logic [0:15] temp2;
logic signed [0:142] temp_packet;
logic [0:2] latency, latency_o;
logic [0:31] instruction_o;

logic [0:31] LSA_o, PC_o, PC1_o, PC2_o, PC3_o, LSA5_o; //32-bit address
logic wr_en_o, wr_en1_o,wr_en2_o, wr_en3_o, wr_en4_o, wr_en5_o, wr_en6_o,wr_en7_o, wr_en8_o;
logic signed [0:127]rt_o;
logic [0:31] temp2_o, temp3_o;
logic [0:27] temp1_o;
logic [0:29] temp_o;
logic [0:7] mem [32768];
logic [0:31] LSLR;
logic signed [0:142] temp_packet_o;
logic [0:3] UnitID_o, UnitID2_o, UnitID3_o, UnitID4_o, UnitID5_o, UnitID6_o, UnitID7_o;
logic signed [0:127] temp_rt_o, tp_o;
logic signed [0:142] rt1_o, rt2_o, rt3_o, rt4_o, rt5_o, rt6_o, rt7_o;
logic signed [0:142] FW_rt1_o, FW_rt2_o, FW_rt3_o, FW_rt4_o, FW_rt5_o, FW_rt6_o, FW_rt7_o;
logic signed [0:142] rt1_LS_o, rt2_LS_o, rt3_LS_o, rt4_LS_o, rt5_LS_o, rt6_LS_o, rt1_BR_o, rt2_BR_o, rt3_BR_o, rt4_BR_o, rt1_Perm_o, rt2_Perm_o, rt3_Perm_o;
logic branch_taken_1_o, branch_taken_2_o, branch_taken_3_o, branch_taken_o, branch_taken_3cycles_o, branch_taken_ahead1_o, branch_taken_ahead2_o, branch_taken_ahead3_o;

logic [0:7] Memory [32768];
logic block1_valid, block2_valid;
logic [0:7] tag_block1, tag_block2;
logic block_select, miss_packet, miss, missss, miss1, miss2, miss3, miss4, miss5;









always_ff @(posedge clk) begin 

	flush_for4cycles1<=flush_for4cycles; flush_for4cycles2<=flush_for4cycles1; flush_for4cycles3<=flush_for4cycles2; 
	flush_for4cycles4<=flush_for4cycles3;  flush_for4cycles5<=flush_for4cycles4; flush_for4cycles6<=flush_for4cycles5; 
	flush_for4cycles7<=flush_for4cycles6;

end






always_ff @(posedge clk) begin 

	if(miss && pc[0:7]>=0) block1_valid=1;
	if (miss && pc[0:7]>=1) block2_valid=1;
		
	if(miss && pc[7]==0)  tag_block1<=pc[0:7]; 
	if(miss && pc[7]==1) tag_block2<=pc[0:7]; 

end

always_comb begin
	
	//block1_valid=0; block2_valid=0;
	//tag_block1=0; 
	//tag_block2=0;
	//tag_block1= pc[0:6];
	
	if(miss)
	begin
		if(pc[7]==0)
		for(int i=0; i<128; i++)
		cache[i] = Memory[i+pc];
		
		else if (pc[7]==1)
		for(int i=0; i<128; i++)
		cache[i+128] = Memory[i+pc];
		
		//block1_valid=1;
		
	
	end
	

end




always_ff @(posedge clk) begin
	br_taken1<= br_taken; br_taken2<= br_taken1; br_taken3<= br_taken2; 
	br_taken4<= br_taken3; br_taken5<= br_taken4; br_taken6<= br_taken5; br_taken7<= br_taken6; 
	br_add1<= br_add; br_add2<= br_add1; br_add3<= br_add2; 
	Finish1<=Finish; Finish2<=Finish1; Finish3<=Finish2; Finish4<=Finish3; Finish5<=Finish4; Finish6<=Finish5; Finish7<=Finish6; 
	Finish8<=Finish7;  
	if(Finish8)
		$finish;
	
	end


/////////////////////////Issue
always_ff @(posedge clk) begin 
			delaypipe1 <= delaypipe; instruction1_issue1<=instruction1_issue; instruction2_issue1<=instruction2_issue;
			instr1_is_even2 <= instr1_is_even1; instr2_is_even2 <= instr2_is_even1;
	 if (instr1_is_even1 && instr2_is_even1!=1 && !strhazard1 && !waw_hazard2 && !stall) begin instruction_RegFetch_e <= instruction1_issue; instruction_RegFetch_o <= instruction2_issue; end
	else if (!instr1_is_even1 && instr2_is_even1 && !strhazard1 && !waw_hazard2 && !stall) begin instruction_RegFetch_e <= instruction2_issue; instruction_RegFetch_o <= instruction1_issue;end
	else if (instr1_is_even1 && instr2_is_even1 && !strhazard1 && !waw_hazard2 && !stall) begin instruction_RegFetch_e <= instruction1_issue; instruction_RegFetch_o <= 32'bx; end
	else if (!instr1_is_even1 && !instr2_is_even1 && !strhazard1 && !waw_hazard2 && !stall) begin instruction_RegFetch_o <= instruction1_issue; instruction_RegFetch_e <= 32'bx; end
	else if (instr1_is_even2 && instr2_is_even2 && strhazard1 && !waw_hazard2 && !stall) begin instruction_RegFetch_e <= instruction1_issue; instruction_RegFetch_o <= 32'bx; end
	else if (!instr1_is_even2 && !instr2_is_even2 && strhazard1 && !waw_hazard2 && !stall) begin instruction_RegFetch_o <= instruction1_issue; instruction_RegFetch_e <= 32'bx; end
	else if (instr1_is_even2 && !instr2_is_even2 && !strhazard1 && waw_hazard2 && !stall) begin instruction_RegFetch_e <= instruction1_issue; instruction_RegFetch_o <= instruction2_issue; end//2nd instruction after waw_hazard
	else if (!instr1_is_even2 && instr2_is_even2 && !strhazard1 && waw_hazard2 && !stall) begin instruction_RegFetch_o <= instruction2_issue; instruction_RegFetch_e <= instruction1_issue; end
	
	else if (instr1_is_even2 && instr2_is_even2 && strhazard1 && waw_hazard2 && !stall) begin instruction_RegFetch_e <= instruction1_issue; instruction_RegFetch_o <= 32'bx; end
	else if (!instr1_is_even2 && !instr2_is_even2 && strhazard1 && waw_hazard2 && !stall) begin instruction_RegFetch_o <= instruction2_issue; instruction_RegFetch_e <= 32'bx; end
	
	else if (stall) begin instruction_RegFetch_e <=instruction_RegFetch_e; instruction_RegFetch_o <=instruction_RegFetch_o; end
	else if (instruction1_issue[0:10] == 11'b01011011000) instruction_RegFetch_o <= instruction1_issue;
	//else if (instr1_is_even2 && instr2_is_even2 && delaypipe1==1) begin instruction_RegFetch_e <= instructionsave; instruction_RegFetch_o <= 32'bx; instructionsave<=32'bx; end
	//else if (!instr1_is_even2 && !instr2_is_even2 && delaypipe1==1) begin instruction_RegFetch_o <= instructionsave; instruction_RegFetch_e <= 32'bx;instructionsave<=32'bx; end
	
	//////Halt
	else if (instruction1_issue[0:10] == 11'b01111011000)  
		instruction_RegFetch_o <= instruction1_issue;
	else if (instruction2_issue[0:10] == 11'b01111011000) 
		instruction_RegFetch_o <= instruction2_issue;
	
	//else if(instr1_is_even1 && !strhazard1 && !waw_hazard2 && !stall) instruction_RegFetch_e <= instruction1_issue;
	
	
	
	
	
	
	
	
	
	
	
	else begin instruction_RegFetch_e <= 32'bx;instruction_RegFetch_o <= 32'bx; instructionsave <= 32'bx; end
		
	end
	/*
always_ff @(posedge clk) begin
	delaypipe1 <= delaypipe;
	if(delaypipe==1 && instr1_is_even && instr2_is_even) instruction_RegFetch_e <= instruction2_issue;
	else if(delaypipe==1 && !instr1_is_even && !instr2_is_even) instruction_RegFetch_e <= instruction2_issue;
end
	*/
	

always_ff @(posedge clk) begin instruction_decode_delay1<= instruction_decode1; instruction_decode_delay2<= instruction_decode2; end
	
always_ff @(posedge clk) begin stall_for_cycles1<=stall_for_cycles; stall_for_cycles2<=stall_for_cycles1; end	
always_ff @(posedge clk) begin strhazard1 <= strhazard; waw_hazard1 <= waw_hazard; waw_hazard2<=waw_hazard1; stall1<=stall; stall2<= stall1; end
	
always_ff @(posedge clk) begin 
	
	if (instr1_is_even && instr2_is_even && strhazard==0 && !waw_hazard && !waw_hazard1 && !stall) begin/////both even then activate str hazard and not considering waw_hazard
	instruction1_issue <= instruction_decode1; 
	instruction2_issue <= 32'bx; 
	strhazard=1;
	end
	
	else if (!instr1_is_even && !instr2_is_even && strhazard==0 && !waw_hazard && !waw_hazard1 && !stall) begin /////both odd then activate str hazard and not considering waw_hazard
	instruction1_issue <= instruction_decode1; 
	instruction2_issue <= 32'bx; 
	strhazard=1;
	end
	
	
	
	
	
	///for both decode hazards the 1st instr
	else if (instr1_is_even && instr2_is_even && strhazard==0 && waw_hazard && !waw_hazard1 && !stall) begin/////both even then activate str hazard and not considering waw_hazard
	instruction1_issue <= instruction_decode1; 
	instruction2_issue <= 32'bx; 
	strhazard=1;
	end
	
	else if (!instr1_is_even && !instr2_is_even && strhazard==0 && waw_hazard && !waw_hazard1 && !stall) begin /////both odd then activate str hazard and not considering waw_hazard
	instruction1_issue <= instruction_decode1; 
	instruction2_issue <= 32'bx; 
	strhazard=1;
	end
	////////////////////////////////
	
	
	
	
	///looking at the waveforms
	else if (instr1_is_even1 && instr2_is_even1 && strhazard==1 && waw_hazard && !waw_hazard1 && !stall) begin/////both even then activate str hazard and not considering waw_hazard
	instruction1_issue <= instruction_decode_delay2; 
	instruction2_issue <= 32'bx; 
	strhazard=1;
	end
	
	else if (!instr1_is_even1 && !instr2_is_even1 && strhazard==1 && waw_hazard && !waw_hazard1 && !stall) begin /////both odd then activate str hazard and not considering waw_hazard
	instruction1_issue <= 32'bx; 
	instruction2_issue <= instruction_decode_delay2;
	strhazard=1;
	end
	////////////////////////////////
	
	
	
	
	
	
	
	
	
	
	
	
	
	else if (strhazard && !waw_hazard && !waw_hazard1 && !stall) begin//load the 2nd instruction of str hazard
	instruction1_issue <= instruction_decode_delay2; 
	instruction2_issue <= 32'bx;
	strhazard=0; 	
	end
	
	///////////////waw hazard
	else if (instr1_is_even && waw_hazard && !stall) begin//if 1st instr is even then execute 1st in even pipe
	instruction1_issue <= instruction_decode1; 
	instruction2_issue <= 32'bx;
	strhazard=0; 
	end
	
	else if (!instr1_is_even && waw_hazard && !stall) begin//if 1st instr is odd then execute 1st in odd pipe
	instruction1_issue <= instruction_decode1; 
	instruction2_issue <= 32'bx;
	strhazard=0; 
	end
	
	else if (instr2_is_even1 && waw_hazard1 && !stall) begin//if 2st instr is even then execute 2st in even pipe
	instruction1_issue <= instruction_decode_delay2; 
	instruction2_issue <= 32'bx;
	strhazard=0; 
	end
	
	else if (!instr2_is_even1 && waw_hazard1 && !stall) begin//if 2st instr is odd then execute 2st in odd pipe
	instruction1_issue <= 32'bx; 
	instruction2_issue <= instruction_decode_delay2;
	strhazard=0; 
	end
	////////////////////
	
	
	
	else if (stall) begin
	instruction1_issue <= instruction1_issue; 
	instruction2_issue <= instruction2_issue;
	
	
	end
	
	
	
	
	
	
	
	
	else begin 
	instruction1_issue <= instruction_decode1; 
	instruction2_issue <= instruction_decode2;
	strhazard=0;
	end
	
	
end
	
	
	
always_ff @(posedge clk) begin
	
	if(!stall) begin
	instr1_is_even1 <= instr1_is_even; instr2_is_even1 <= instr2_is_even; end
	
end
	
always_ff @(posedge clk) begin
	miss1<=miss_packet; 
	
	if(miss_packet && !miss1) miss2<=1; else miss2<=0;
	
	
	miss3<=miss2;miss4<=miss3;miss5<=miss4; miss<=miss5; missss<=miss;
	end
	
always_ff @(posedge clk) begin
	addr_rt1 <= addr_rt;addr_rt2 <= addr_rt1;addr_rt3 <= addr_rt2;addr_rt4 <= addr_rt3;addr_rt5 <= addr_rt4;addr_rt6 <= addr_rt5;addr_rt6 <= addr_rt5;
	addr_rt7 <= addr_rt6;addr_rt8 <= addr_rt7;addr_rt9 <= addr_rt8;
	addr_rt1_o <= addr_rt_o;addr_rt2_o <= addr_rt1_o;addr_rt3_o <= addr_rt2_o;addr_rt4_o <= addr_rt3_o;addr_rt5_o <= addr_rt4_o;addr_rt6_o <= addr_rt5_o;
	addr_rt6_o <= addr_rt5_o;addr_rt7_o <= addr_rt6_o;addr_rt8_o <= addr_rt7_o;addr_rt9_o <= addr_rt8_o;
		
	end
	
always_ff @(posedge clk) begin
if(incrpc==1'b0 ) pc<=0;
else if ((stall_onlyone == 1 || waw_hazard==1 || stall==1 || miss) && br_taken3!=1) pc<=pc;
else if (miss5==1 && pc==56 && br_taken3!=1) pc<= pc-56;
else if (miss5==1 && block1_valid==1 && br_taken3!=1) pc<= pc-64;
else if (br_taken3==1) pc<=br_add3;

else pc<=pc+8;

end





always_ff @(posedge clk) begin
	if(stall==0 /*&& br_taken3!=1*/) begin
	instruction_decode1 <= twoinstructions[0:31];
	instruction_decode2 <= twoinstructions[32:63];
	end
	
	else if (br_taken3) begin
	instruction_decode1 <= 32'bx;
	instruction_decode2 <= 32'bx;
	end
	
end





always_comb begin

	if ((instruction_decode1[0:10]==11'b00011001000 || 
		instruction_decode1[0:10]==11'b00011000000 ||
		instruction_decode1[0:10]==11'b00001001000 ||
		instruction_decode1[0:10]==11'b00001000000 ||
		instruction_decode1[0:10]==11'b01101000000 ||
		instruction_decode1[0:10]==11'b01101000001 ||
		instruction_decode1[0:10] == 11'b01101000010 ||
		instruction_decode1[0:10] == 11'b00001000010 ||
		instruction_decode1[0:10]==11'b01111000100 ||
		instruction_decode1[0:3]==4'b1100 ||
		instruction_decode1[0:10]==11'b00011000001 ||
		instruction_decode1[0:10]==11'b00001000001 ||
		instruction_decode1[0:10]==11'b00011000001 ||
		instruction_decode1[0:10]==11'b00011001001 ||
		instruction_decode1[0:10]==11'b00001001001 ||
		instruction_decode1[0:10]==11'b01010110100 ||
		instruction_decode1[0:10]==11'b00001011111 ||
		instruction_decode1[0:10]==11'b00001111111 ||
		instruction_decode1[0:10]==11'b00001011011 ||
		instruction_decode1[0:10]==11'b00001111011 ||
		instruction_decode1[0:10]==11'b00001011100 ||
		instruction_decode1[0:10]==11'b00001111100 ||
		instruction_decode1[0:10]==11'b00001011000 ||
		instruction_decode1[0:10]==11'b00001111000 ||
		instruction_decode1[0:10]==11'b01111010000 ||
		instruction_decode1[0:7]==8'b01111110 ||
		instruction_decode1[0:10]==11'b01001010000 ||
		instruction_decode1[0:7]==8'b01001110 ||
		instruction_decode1[0:7]==8'b00011101 ||
		instruction_decode1[0:7]==8'b01110100 ||
		instruction_decode1[0:7]==11'b00001101 ||
		instruction_decode1[0:7]==8'b00011100 ||
		instruction_decode1[0:7]==8'b00001100 ||
		instruction_decode1[0:7]==8'b00010110 ||
		instruction_decode1[0:7]==8'b00000110 ||
		instruction_decode1[0:7]==8'b01000110 ||
		instruction_decode1[0:10] == 11'b01011000100 ||
		instruction_decode1[0:10] == 11'b01011000101 ||
		instruction_decode1[0:10] == 11'b01011000110 ||
		instruction_decode1[0:3] == 4'b1110 ||
		instruction_decode1[0:3] == 4'b1111 ||
		instruction_decode1[0:10] == 11'b01111000010 ||
		instruction_decode1[0:10] == 11'b01011000010 ||
		instruction_decode1[0:10]==11'b00011010011 ||
		instruction_decode1[0:10]==11'b00001010011 ||
		instruction_decode1[0:10]==11'b01001010011 ||
		instruction_decode1[0:10] == 11'b01000000001 ||
		instruction_decode1[0:8]==9'b010000011 ||
		instruction_decode1[0:8]==9'b010000010 ||
		instruction_decode1[0:8]==9'b010000001 ||
		instruction_decode1[0:6]==7'b0100001		
		) && strhazard==0)///////to make it for only 1 cycle in case of str hazard
			
			
			
			instr1_is_even=1;
		
		
		
		
		
		else if ((
		instruction_decode1[0:7] == 8'b00110100 ||
		instruction_decode1[0:7] == 8'b00100100 ||
		instruction_decode1[0:10] == 11'b00111000100 ||
		instruction_decode1[0:10] == 11'b00101000100 ||
		instruction_decode1[0:8] == 9'b001100111 ||
		instruction_decode1[0:8] == 9'b001000111 ||
		instruction_decode1[0:10] == 11'b00111011011 ||
		instruction_decode1[0:10] == 11'b00111011111 ||
		instruction_decode1[0:10] == 11'b00111011100 ||
		instruction_decode1[0:8] == 9'b001100100 ||
		instruction_decode1[0:8] == 9'b001100000 ||
		instruction_decode1[0:8] == 9'b001100010 ||
		instruction_decode1[0:8] == 9'b001000010 ||
		instruction_decode1[0:8] == 9'b001000000 ||
		instruction_decode1[0:8] == 9'b001000110 ||
		instruction_decode1[0:8] == 9'b001000100 ||
		instruction_decode1[0:10] == 11'b00000000001 ||
		instruction_decode1[0:10] == 11'b01111011000 ||
		instruction_decode1[0:7] == 8'b01111111 ||
		instruction_decode1[0:10] == 11'b01001011000 ||
		instruction_decode1[0:7] == 8'b01001111	
		
		) && strhazard==0)
			
			
			instr1_is_even=0;
		
		
		else instr1_is_even= 1'bx;
		
		
		
		
		
		
		
		
		
	if (instruction_decode2[0:10]==11'b00011001000 || 
		instruction_decode2[0:10]==11'b00011000000 ||
		instruction_decode2[0:10]==11'b00001001000 ||
		instruction_decode2[0:10]==11'b00001000000 ||
		instruction_decode2[0:10]==11'b01101000000 ||
		instruction_decode2[0:10]==11'b01101000001 ||
		instruction_decode2[0:10] == 11'b01101000010 ||
		instruction_decode2[0:10] == 11'b00001000010 ||
		instruction_decode2[0:10]==11'b01111000100 ||
		instruction_decode2[0:3]==4'b1100 ||
		instruction_decode2[0:10]==11'b00011000001 ||
		instruction_decode2[0:10]==11'b00001000001 ||
		instruction_decode2[0:10]==11'b00011000001 ||
		instruction_decode2[0:10]==11'b00011001001 ||
		instruction_decode2[0:10]==11'b00001001001 ||
		instruction_decode2[0:10]==11'b01010110100 ||
		instruction_decode2[0:10]==11'b00001011111 ||
		instruction_decode2[0:10]==11'b00001111111 ||
		instruction_decode2[0:10]==11'b00001011011 ||
		instruction_decode2[0:10]==11'b00001111011 ||
		instruction_decode2[0:10]==11'b00001011100 ||
		instruction_decode2[0:10]==11'b00001111100 ||
		instruction_decode2[0:10]==11'b00001011000 ||
		instruction_decode2[0:10]==11'b00001111000 ||
		instruction_decode2[0:10]==11'b01111010000 ||
		instruction_decode2[0:7]==8'b01111110 ||
		instruction_decode2[0:10]==11'b01001010000 ||
		instruction_decode2[0:7]==8'b01001110 ||
		instruction_decode2[0:7]==8'b00011101 ||
		instruction_decode2[0:7]==8'b01110100 ||
		instruction_decode2[0:7]==11'b00001101 ||
		instruction_decode2[0:7]==8'b00011100 ||
		instruction_decode2[0:7]==8'b00001100 ||
		instruction_decode2[0:7]==8'b00010110 ||
		instruction_decode2[0:7]==8'b00000110 ||
		instruction_decode2[0:7]==8'b01000110 ||
		instruction_decode2[0:10] == 11'b01011000100 ||
		instruction_decode2[0:10] == 11'b01011000101 ||
		instruction_decode2[0:10] == 11'b01011000110 ||
		instruction_decode2[0:3] == 4'b1110 ||
		instruction_decode2[0:3] == 4'b1111 ||
		instruction_decode2[0:10] == 11'b01111000010 ||
		instruction_decode2[0:10] == 11'b01011000010 ||
		instruction_decode2[0:10]==11'b00011010011 ||
		instruction_decode2[0:10]==11'b00001010011 ||
		instruction_decode2[0:10]==11'b01001010011 ||
		instruction_decode2[0:10] == 11'b01000000001 ||
		instruction_decode2[0:8]==9'b010000011 ||
		instruction_decode2[0:8]==9'b010000010 ||
		instruction_decode2[0:8]==9'b010000001 ||
		instruction_decode2[0:6]==7'b0100001		
		) 
			instr2_is_even=1;
		
		
		
		
		
		else if (
		instruction_decode2[0:7] == 8'b00110100 ||
		instruction_decode2[0:7] == 8'b00100100 ||
		instruction_decode2[0:10] == 11'b00111000100 ||
		instruction_decode2[0:10] == 11'b00101000100 ||
		instruction_decode2[0:8] == 9'b001100111 ||
		instruction_decode2[0:8] == 9'b001000111 ||
		instruction_decode2[0:10] == 11'b00111011011 ||
		instruction_decode2[0:10] == 11'b00111011111 ||
		instruction_decode2[0:10] == 11'b00111011100 ||
		instruction_decode2[0:8] == 9'b001100100 ||
		instruction_decode2[0:8] == 9'b001100000 ||
		instruction_decode2[0:8] == 9'b001100010 ||
		instruction_decode2[0:8] == 9'b001000010 ||
		instruction_decode2[0:8] == 9'b001000000 ||
		instruction_decode2[0:8] == 9'b001000110 ||
		instruction_decode2[0:8] == 9'b001000100 ||
		instruction_decode2[0:10] == 11'b00000000001 ||
		instruction_decode2[0:10] == 11'b01111011000 ||
		instruction_decode2[0:7] == 8'b01111111 ||
		instruction_decode2[0:10] == 11'b01001011000 ||
		instruction_decode2[0:7] == 8'b01001111	
		
		)
			instr2_is_even=0;
			
		else instr2_is_even= 1'bx;



		
		if ((instruction_decode1[25:31] == instruction_decode2[25:31]) && !waw_hazard1) waw_hazard=1;////waw_hazard1 because waw_hazard should be 1 only for 1 clock cycle
			else waw_hazard=0;
		
		


end






always_comb begin
	
	if (block1_valid==1 && (pc[0:7] == tag_block1) )
	for (int i=0;i<64;i+=8)	
	twoinstructions [i+:8] = cache[i/8+pc[8:14]];
	
	
	else if (block2_valid==1 && pc[0:7] == tag_block2)
	for (int i=0;i<64;i+=8)	
	twoinstructions [i+:8] = cache[i/8+pc[8:14]+128];
	
	//else if (block2_valid!=1)
	
	else begin twoinstructions[0:10] = 11'b01011011000; twoinstructions[11:63] = 53'bx; end
	
end

always_ff @(posedge clk) begin latency<=temp_packet[140:142]; latency_o <= temp_packet_o; end

always_ff @(posedge clk) begin
	
	if (stall && !stall1)//only when stall transitions from 0 to 1
		count_latency<=0;
		
		else  count_latency<= count_latency+1;
		


end


/*
always_ff @(posedge clk) begin
if (stall1==1 && !stall2)
stall_for_cycles =temp_packet_o[140:142]; 

end
*/


always_comb 
begin
	stall=1'b0;
	
	
	
	/*
	if(addr_ra_o==addr_rt)
		begin
		
			if(instruction1_issue1==)
		
		
		end
	
	*/
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////ra_o
		/////for latency 7
	if (((addr_ra_o == addr_rt1) && temp_packet[140:142]==7) ||
		((addr_ra_o == addr_rt2) && rt1[140:142]==7) ||
		((addr_ra_o == addr_rt3) && rt2[140:142]==7) ||
		((addr_ra_o == addr_rt4) && rt3[140:142]==7) ||
		((addr_ra_o == addr_rt5) && rt4[140:142]==7) ||
		((addr_ra_o == addr_rt6) && rt5[140:142]==7) ||
		((addr_ra_o == addr_rt7) && rt6[140:142]==7) ) 
	begin		
		stall=1;		
	end
	
	////////for latency 2
	if (((addr_ra_o == temp_packet[133:139]) && temp_packet[140:142]==2) ||
	((addr_ra_o == rt1[133:139]) && rt1[140:142]==2) ) 
	begin		
		stall=1;		
	end
	
	////////for latency 4
	if (((addr_ra_o == temp_packet[133:139]) && temp_packet[140:142]==4) ||
	((addr_ra_o == rt1[133:139]) && rt1[140:142]==4) || 
	((addr_ra_o == rt2[133:139]) && rt2[140:142]==4) ||
	((addr_ra_o == rt3[133:139]) && rt3[140:142]==4)  ) 
	begin		
		stall=1;		
	end
	
	/////for latency 6
	if (((addr_ra_o == addr_rt1) && temp_packet[140:142]==6) ||
		((addr_ra_o == addr_rt2) && rt1[140:142]==6) ||
		((addr_ra_o == addr_rt3) && rt2[140:142]==6) ||
		((addr_ra_o == addr_rt4) && rt3[140:142]==6) ||
		((addr_ra_o == addr_rt5) && rt4[140:142]==6) ||
		((addr_ra_o == addr_rt6) && rt5[140:142]==6) ) 
	begin		
		stall=1;		
	end
	////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	////////////////////////////////////////////////////////////rb_o
		/////for latency 7
	if (((addr_rb_o == addr_rt1) && temp_packet[140:142]==7) ||
		((addr_rb_o == addr_rt2) && rt1[140:142]==7) ||
		((addr_rb_o == addr_rt3) && rt2[140:142]==7) ||
		((addr_rb_o == addr_rt4) && rt3[140:142]==7) ||
		((addr_rb_o == addr_rt5) && rt4[140:142]==7) ||
		((addr_rb_o == addr_rt6) && rt5[140:142]==7) ||
		((addr_rb_o == addr_rt7) && rt6[140:142]==7) ) 
	begin		
		stall=1;		
	end
	
	////////for latency 2
	if (((addr_rb_o == temp_packet[133:139]) && temp_packet[140:142]==2) ||
	((addr_rb_o == rt1[133:139]) && rt1[140:142]==2) ) 
	begin		
		stall=1;		
	end
	
	////////for latency 4
	if (((addr_rb_o == temp_packet[133:139]) && temp_packet[140:142]==4) ||
	((addr_rb_o == rt1[133:139]) && rt1[140:142]==4) || 
	((addr_rb_o == rt2[133:139]) && rt2[140:142]==4) ||
	((addr_rb_o == rt3[133:139]) && rt3[140:142]==4)  ) 
	begin		
		stall=1;		
	end
	
	/////for latency 6
	if (((addr_rb_o == addr_rt1) && temp_packet[140:142]==6) ||
		((addr_rb_o == addr_rt2) && rt1[140:142]==6) ||
		((addr_rb_o == addr_rt3) && rt2[140:142]==6) ||
		((addr_rb_o == addr_rt4) && rt3[140:142]==6) ||
		((addr_rb_o == addr_rt5) && rt4[140:142]==6) ||
		((addr_rb_o == addr_rt6) && rt5[140:142]==6) ) 
	begin		
		stall=1;		
	end
	////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////ra
		/////for latency 7
	if (((addr_ra == addr_rt1) && temp_packet[140:142]==7) ||
		((addr_ra == addr_rt2) && rt1[140:142]==7) ||
		((addr_ra == addr_rt3) && rt2[140:142]==7) ||
		((addr_ra == addr_rt4) && rt3[140:142]==7) ||
		((addr_ra == addr_rt5) && rt4[140:142]==7) ||
		((addr_ra == addr_rt6) && rt5[140:142]==7) ||
		((addr_ra == addr_rt7) && rt6[140:142]==7) ) 
	begin		
		stall=1;		
	end
	
	////////for latency 2
	if (((addr_ra == temp_packet[133:139]) && temp_packet[140:142]==2) ||
	((addr_ra == rt1[133:139]) && rt1[140:142]==2) ) 
	begin		
		stall=1;		
	end
	
	////////for latency 4
	if (((addr_ra == temp_packet[133:139]) && temp_packet[140:142]==4) ||
	((addr_ra == rt1[133:139]) && rt1[140:142]==4) || 
	((addr_ra == rt2[133:139]) && rt2[140:142]==4) ||
	((addr_ra == rt3[133:139]) && rt3[140:142]==4)  ) 
	begin		
		stall=1;		
	end
	
	/////for latency 6
	if (((addr_ra == addr_rt1) && temp_packet[140:142]==6) ||
		((addr_ra == addr_rt2) && rt1[140:142]==6) ||
		((addr_ra == addr_rt3) && rt2[140:142]==6) ||
		((addr_ra == addr_rt4) && rt3[140:142]==6) ||
		((addr_ra == addr_rt5) && rt4[140:142]==6) ||
		((addr_ra == addr_rt6) && rt5[140:142]==6) ) 
	begin		
		stall=1;		
	end
	////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	////////////////////////////////////////////////////////////rb
		/////for latency 7
	if (((addr_rb == addr_rt1) && temp_packet[140:142]==7) ||
		((addr_rb == addr_rt2) && rt1[140:142]==7) ||
		((addr_rb == addr_rt3) && rt2[140:142]==7) ||
		((addr_rb == addr_rt4) && rt3[140:142]==7) ||
		((addr_rb == addr_rt5) && rt4[140:142]==7) ||
		((addr_rb == addr_rt6) && rt5[140:142]==7) ||
		((addr_rb == addr_rt7) && rt6[140:142]==7) ) 
	begin		
		stall=1;		
	end
	
	////////for latency 2
	if (((addr_rb == temp_packet[133:139]) && temp_packet[140:142]==2) ||
	((addr_rb == rt1[133:139]) && rt1[140:142]==2) ) 
	begin		
		stall=1;		
	end
	
	////////for latency 4
	if (((addr_rb == temp_packet[133:139]) && temp_packet[140:142]==4) ||
	((addr_rb == rt1[133:139]) && rt1[140:142]==4) || 
	((addr_rb == rt2[133:139]) && rt2[140:142]==4) ||
	((addr_rb == rt3[133:139]) && rt3[140:142]==4)  ) 
	begin		
		stall=1;		
	end
	
	/////for latency 6
	if (((addr_rb == addr_rt1) && temp_packet[140:142]==6) ||
		((addr_rb == addr_rt2) && rt1[140:142]==6) ||
		((addr_rb == addr_rt3) && rt2[140:142]==6) ||
		((addr_rb == addr_rt4) && rt3[140:142]==6) ||
		((addr_rb == addr_rt5) && rt4[140:142]==6) ||
		((addr_rb == addr_rt6) && rt5[140:142]==6) ) 
	begin		
		stall=1;		
	end
	////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	
	
	
	
	
	
	
	
	//////////Comparing odd pipes addr_rt_o
	////////////////////////////////////////////////////////////ra_o
		/////for latency 6
	if (((addr_ra_o == temp_packet_o[133:139]) && temp_packet_o[140:142]==6) ||
		((addr_ra_o == rt1_o[133:139]) && rt1_o[140:142]==6) ||
		((addr_ra_o == rt2_o[133:139]) && rt2_o[140:142]==6) ||
		((addr_ra_o == rt3_o[133:139]) && rt3_o[140:142]==6) ||
		((addr_ra_o == rt4_o[133:139]) && rt4_o[140:142]==6) ||
		((addr_ra_o == rt5_o[133:139]) && rt5_o[140:142]==6) ) 
	begin		
		stall=1;		
	end
	
	
	////////for latency 4
	if (((addr_ra_o == temp_packet_o[133:139]) && temp_packet_o[140:142]==4) ||
	((addr_ra_o == rt1_o[133:139]) && rt1_o[140:142]==4) || 
	((addr_ra_o == rt2_o[133:139]) && rt2_o[140:142]==4) ||
	((addr_ra_o == rt3_o[133:139]) && rt3_o[140:142]==4)  ) 
	begin		
		stall=1;		
	end
	
	////////////////////////////////////////////////////////////////////////////////
	
	
	
	////////////////////////////////////////////////////////////rb_o
		/////for latency 6
	if (((addr_rb_o == temp_packet_o[133:139]) && temp_packet_o[140:142]==6) ||
		((addr_rb_o == rt1_o[133:139]) && rt1_o[140:142]==6) ||
		((addr_rb_o == rt2_o[133:139]) && rt2_o[140:142]==6) ||
		((addr_rb_o == rt3_o[133:139]) && rt3_o[140:142]==6) ||
		((addr_rb_o == rt4_o[133:139]) && rt4_o[140:142]==6) ||
		((addr_rb_o == rt5_o[133:139]) && rt5_o[140:142]==6) ) 
	begin		
		stall=1;		
	end
	
	
	////////for latency 4
	if (((addr_rb_o == temp_packet_o[133:139]) && temp_packet_o[140:142]==4) ||
	((addr_rb_o == rt1_o[133:139]) && rt1_o[140:142]==4) || 
	((addr_rb_o == rt2_o[133:139]) && rt2_o[140:142]==4) ||
	((addr_rb_o == rt3_o[133:139]) && rt3_o[140:142]==4)  ) 
	begin		
		stall=1;		
	end
	
	////////////////////////////////////////////////////////////////////////////////
	
	
	
	////////////////////////////////////////////////////////////rb
		/////for latency 6
	if (((addr_rb == temp_packet_o[133:139]) && temp_packet_o[140:142]==6) ||
		((addr_rb == rt1_o[133:139]) && rt1_o[140:142]==6) ||
		((addr_rb == rt2_o[133:139]) && rt2_o[140:142]==6) ||
		((addr_rb == rt3_o[133:139]) && rt3_o[140:142]==6) ||
		((addr_rb == rt4_o[133:139]) && rt4_o[140:142]==6) ||
		((addr_rb == rt5_o[133:139]) && rt5_o[140:142]==6) ) 
	begin		
		stall=1;		
	end
	
	
	////////for latency 4
	if (((addr_rb == temp_packet_o[133:139]) && temp_packet_o[140:142]==4) ||
	((addr_rb == rt1_o[133:139]) && rt1_o[140:142]==4) || 
	((addr_rb == rt2_o[133:139]) && rt2_o[140:142]==4) ||
	((addr_rb == rt3_o[133:139]) && rt3_o[140:142]==4)  ) 
	begin		
		stall=1;		
	end
	
	////////////////////////////////////////////////////////////////////////////////
	
	
	
	////////////////////////////////////////////////////////////ra
		/////for latency 6
	if (((addr_ra == temp_packet_o[133:139]) && temp_packet_o[140:142]==6) ||
		((addr_ra == rt1_o[133:139]) && rt1_o[140:142]==6) ||
		((addr_ra == rt2_o[133:139]) && rt2_o[140:142]==6) ||
		((addr_ra == rt3_o[133:139]) && rt3_o[140:142]==6) ||
		((addr_ra == rt4_o[133:139]) && rt4_o[140:142]==6) ||
		((addr_ra == rt5_o[133:139]) && rt5_o[140:142]==6) ) 
	begin		
		stall=1;		
	end
	
	
	////////for latency 4
	if (((addr_ra == temp_packet_o[133:139]) && temp_packet_o[140:142]==4) ||
	((addr_ra == rt1_o[133:139]) && rt1_o[140:142]==4) || 
	((addr_ra == rt2_o[133:139]) && rt2_o[140:142]==4) ||
	((addr_ra == rt3_o[133:139]) && rt3_o[140:142]==4)  ) 
	begin		
		stall=1;		
	end
	
	////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
end



always_comb begin 
	if (br_taken3==1 || br_taken4==1 ||br_taken5==1 ||br_taken6==1)
	flush=1;
	else flush=0;

end



always_ff @(posedge clk) begin
	
	if(stall==0 && !flush==1) begin
	instruction_o <= instruction_RegFetch_o;
	instruction <= instruction_RegFetch_e;
	end
	
	else if (stall==1 && stall1==0 && !flush==1) begin
	instruction_o <= instruction_RegFetch_o;
	instruction <= instruction_RegFetch_e;
	
	end
	
	else if (flush==1)begin
	instruction_o <= 32'bx;
	instruction <= 32'bx;
	
	end
	
	
	else begin
	instruction_o[0:10] <= 11'b00000000001;   //instruction_o[0:10] == 11'b00000000001
	instruction[0:10] <= 11'b01000000001;	//instruction[0:10] == 11'b01000000001
	end
	
end

always_comb
	if(instruction_RegFetch_o == instruction1_issue1)
		br_first=1;
		else br_first=0;

always_ff @(posedge clk) begin
	br_first1<=br_first; br_first2<=br_first1; br_first3<=br_first2; br_first4<=br_first3; br_first5<=br_first4;
end



always_comb begin

	if (br_taken==1 && br_first1==0) flush_for4cycles=0;
		else if ( br_taken==1 && br_first1==1) flush_for4cycles=1;
		else flush_for4cycles=1;


end







always_comb begin 

Memory[0]=8'b00111011; Memory[1]=8'b10000000; Memory[2]=8'b00000011; Memory[3]=8'b00110101; Memory[4]=8'b00011001; Memory[5]=8'b00000001; Memory[6]=8'b01000001; Memory[7]=8'b00110010; 
Memory[8]=8'b00011010; Memory[9]=8'b01100000; Memory[10]=8'b01000011; Memory[11]=8'b10110110; Memory[12]=8'b00111011; Memory[13]=8'b11100001; Memory[14]=8'b01000001; Memory[15]=8'b10111001; 
Memory[16]=8'b00110000; Memory[17]=8'b00000000; Memory[18]=8'b00001101; Memory[19]=8'b00000000; Memory[20]=8'b00001001; Memory[21]=8'b00000011; Memory[22]=8'b01000001; Memory[23]=8'b10110100; 
Memory[24]=8'b00111011; Memory[25]=8'b10000000; Memory[26]=8'b00000010; Memory[27]=8'b10110111; Memory[28]=8'b11000111; Memory[29]=8'b00000001; Memory[30]=8'b10000010; Memory[31]=8'b10000001; 
Memory[32]=8'b00011010; Memory[33]=8'b01100000; Memory[34]=8'b01000011; Memory[35]=8'b10110110; Memory[36]=8'b00111011; Memory[37]=8'b11100001; Memory[38]=8'b01000001; Memory[39]=8'b10111001; 
Memory[40]=8'b00011001; Memory[41]=8'b00000001; Memory[42]=8'b01000001; Memory[43]=8'b00110010; Memory[44]=8'b00111011; Memory[45]=8'b10000000; Memory[46]=8'b00000101; Memory[47]=8'b10110111; 
Memory[48]=8'b11001000; Memory[49]=8'b01000001; Memory[50]=8'b10000010; Memory[51]=8'b10000001; Memory[52]=8'b00111011; Memory[53]=8'b10000000; Memory[54]=8'b00000010; Memory[55]=8'b10110111; 
Memory[56]=8'b00011010; Memory[57]=8'b01100000; Memory[58]=8'b01000011; Memory[59]=8'b11000000; Memory[60]=8'b00111011; Memory[61]=8'b11100001; Memory[62]=8'b01000001; Memory[63]=8'b10111001; 
Memory[64]=8'b00011001; Memory[65]=8'b00000001; Memory[66]=8'b01000001; Memory[67]=8'b00110010; Memory[68]=8'b00111011; Memory[69]=8'b10000000; Memory[70]=8'b00000101; Memory[71]=8'b11000001; 
Memory[72]=8'b00001001; Memory[73]=8'b00000011; Memory[74]=8'b01000001; Memory[75]=8'b10110100; Memory[76]=8'b00111011; Memory[77]=8'b10000000; Memory[78]=8'b00000011; Memory[79]=8'b00110101; 
Memory[80]=8'b11000111; Memory[81]=8'b00000001; Memory[82]=8'b10000010; Memory[83]=8'b10000001; Memory[84]=8'b00111011; Memory[85]=8'b10000000; Memory[86]=8'b00000010; Memory[87]=8'b10110111; 
Memory[88]=8'b00011010; Memory[89]=8'b01100000; Memory[90]=8'b01000011; Memory[91]=8'b10110110; Memory[92]=8'b00111011; Memory[93]=8'b11100001; Memory[94]=8'b01000001; Memory[95]=8'b10111001; 
Memory[96]=8'b00011001; Memory[97]=8'b00000001; Memory[98]=8'b01000001; Memory[99]=8'b00110010; Memory[100]=8'b00111011; Memory[101]=8'b10000000; Memory[102]=8'b00000101; Memory[103]=8'b10110111; 
Memory[104]=8'b11001000; Memory[105]=8'b01000001; Memory[106]=8'b10000010; Memory[107]=8'b10000001; Memory[108]=8'b00111011; Memory[109]=8'b10000000; Memory[110]=8'b00000010; Memory[111]=8'b10110111; 
Memory[112]=8'b00011010; Memory[113]=8'b01100000; Memory[114]=8'b01000011; Memory[115]=8'b11000000; Memory[116]=8'b00111011; Memory[117]=8'b11100001; Memory[118]=8'b01000001; Memory[119]=8'b10111001; 
Memory[120]=8'b00011001; Memory[121]=8'b00000001; Memory[122]=8'b01000001; Memory[123]=8'b00110010; Memory[124]=8'b00111011; Memory[125]=8'b10000000; Memory[126]=8'b00000101; Memory[127]=8'b11000001; 
Memory[128]=8'b11000111; Memory[129]=8'b00000001; Memory[130]=8'b10000010; Memory[131]=8'b10000001; Memory[132]=8'b00111011; Memory[133]=8'b10000000; Memory[134]=8'b00000010; Memory[135]=8'b10110111; 
Memory[136]=8'b00011010; Memory[137]=8'b01100000; Memory[138]=8'b01000011; Memory[139]=8'b10110110; Memory[140]=8'b00111011; Memory[141]=8'b11100001; Memory[142]=8'b01000001; Memory[143]=8'b10111001; 
Memory[144]=8'b00011001; Memory[145]=8'b00000001; Memory[146]=8'b01000001; Memory[147]=8'b00110010; Memory[148]=8'b00111011; Memory[149]=8'b10000000; Memory[150]=8'b00000101; Memory[151]=8'b10110111; 
























	
	if (instruction_o[0:7] == 8'b00100100 || instruction_o[0:10] == 11'b00101000100
		|| instruction_o[0:8] == 9'b001000111)
	Memory[LSA_o]= reg1[addr_rt1_o];

end






////////////////////////////////Register file
	always_ff @(posedge clk) begin
	
	
	//if(count_latency== (stall_for_cycles-1)) ra<=FW_rt4[4:131];
	//if(!stall && stall1) ra<=FW_rt4[4:131];
	//else	
	
	if (FW_rt2_o[133:139] == addr_ra)
		ra<=FW_rt2_o[4:131];
	else if (FW_rt3_o[133:139] == addr_ra)
		ra<=FW_rt3_o[4:131];
	else if (FW_rt4_o[133:139] == addr_ra)
		ra<=FW_rt4_o[4:131];	
	else if (FW_rt5_o[133:139] == addr_ra)
		ra<=FW_rt5_o[4:131];	
	else if (FW_rt6_o[133:139] == addr_ra)
		ra<=FW_rt6_o[4:131];	
	else if (FW_rt7_o[133:139] == addr_ra)
		ra<=FW_rt7_o[4:131];
	else if (FW_rt2[133:139] == addr_ra)
		ra<=FW_rt2[4:131];
	else if (FW_rt3[133:139] == addr_ra)
		ra<=FW_rt3[4:131];
	else if (FW_rt4[133:139] == addr_ra)
		ra<=FW_rt4[4:131];	
	else if (FW_rt5[133:139] == addr_ra)
		ra<=FW_rt5[4:131];	
	else if (FW_rt6[133:139] == addr_ra)
		ra<=FW_rt6[4:131];	
	else if (FW_rt7[133:139] == addr_ra)
		ra<=FW_rt7[4:131];	
	else ra <= reg1[addr_ra];
	
	
	
	if (FW_rt2_o[133:139] == addr_rb)
		rb<=FW_rt2_o[4:131];
	else if (FW_rt3_o[133:139] == addr_rb)
		rb<=FW_rt3_o[4:131];
	else if (FW_rt4_o[133:139] == addr_rb)
		rb<=FW_rt4_o[4:131];	
	else if (FW_rt5_o[133:139] == addr_rb)
		rb<=FW_rt5_o[4:131];	
	else if (FW_rt6_o[133:139] == addr_rb)
		rb<=FW_rt6_o[4:131];	
	else if (FW_rt7_o[133:139] == addr_rb)
		rb<=FW_rt7_o[4:131];	
	else if (FW_rt2[133:139] == addr_rb)
		rb<=FW_rt2[4:131];
	else if (FW_rt3[133:139] == addr_rb)
		rb<=FW_rt3[4:131];
	else if (FW_rt4[133:139] == addr_rb)
		rb<=FW_rt4[4:131];	
	else if (FW_rt5[133:139] == addr_rb)
		rb<=FW_rt5[4:131];	
	else if (FW_rt6[133:139] == addr_rb)
		rb<=FW_rt6[4:131];	
	else if (FW_rt7[133:139] == addr_rb)
		rb<=FW_rt7[4:131];	
	else rb <= reg1[addr_rb];
	
	
	if (FW_rt2_o[133:139] == addr_rc)
		rc<=FW_rt2_o[4:131];
	else if (FW_rt3_o[133:139] == addr_rc)
		rc<=FW_rt3_o[4:131];
	else if (FW_rt4_o[133:139] == addr_rc)
		rc<=FW_rt4_o[4:131];	
	else if (FW_rt5_o[133:139] == addr_rc)
		rc<=FW_rt5_o[4:131];	
	else if (FW_rt6_o[133:139] == addr_rc)
		rc<=FW_rt6_o[4:131];	
	else if (FW_rt7_o[133:139] == addr_rc)
		rc<=FW_rt7_o[4:131];
	else if (FW_rt2[133:139] == addr_rc)
		rc<=FW_rt2[4:131];
	else if (FW_rt3[133:139] == addr_rc)
		rc<=FW_rt3[4:131];
	else if (FW_rt4[133:139] == addr_rc)
		rc<=FW_rt4[4:131];	
	else if (FW_rt5[133:139] == addr_rc)
		rc<=FW_rt5[4:131];	
	else if (FW_rt6[133:139] == addr_rc)
		rc<=FW_rt6[4:131];	
	else if (FW_rt7[133:139] == addr_rc)
		rc<=FW_rt7[4:131];	
	else rc <= reg1[addr_rc];
	
	
	if (FW_rt2[133:139] == addr_ra_o)
		ra_o<=FW_rt2[4:131];
	else if (FW_rt3[133:139] == addr_ra_o)
		ra_o<=FW_rt3[4:131];
	else if (FW_rt4[133:139] == addr_ra_o)
		ra_o<=FW_rt4[4:131];	
	else if (FW_rt5[133:139] == addr_ra_o)
		ra_o<=FW_rt5[4:131];	
	else if (FW_rt6[133:139] == addr_ra_o)
		ra_o<=FW_rt6[4:131];	
	else if (FW_rt7[133:139] == addr_ra_o)
		ra_o<=FW_rt7[4:131];	
	else if (FW_rt2_o[133:139] == addr_ra_o)
		ra_o<=FW_rt2_o[4:131];
	else if (FW_rt3_o[133:139] == addr_ra_o)
		ra_o<=FW_rt3_o[4:131];
	else if (FW_rt4_o[133:139] == addr_ra_o)
		ra_o<=FW_rt4_o[4:131];	
	else if (FW_rt5_o[133:139] == addr_ra_o)
		ra_o<=FW_rt5_o[4:131];	
	else if (FW_rt6_o[133:139] == addr_ra_o)
		ra_o<=FW_rt6_o[4:131];	
	else if (FW_rt7_o[133:139] == addr_ra_o)
		ra_o<=FW_rt7_o[4:131];	
	else ra_o <= reg1[addr_ra_o];
	
	
	
	if (FW_rt2[133:139] == addr_rb_o)
		rb_o<=FW_rt2[4:131];
	else if (FW_rt3[133:139] == addr_rb_o)
		rb_o<=FW_rt3[4:131];
	else if (FW_rt4[133:139] == addr_rb_o)
		rb_o<=FW_rt4[4:131];	
	else if (FW_rt5[133:139] == addr_rb_o)
		rb_o<=FW_rt5[4:131];	
	else if (FW_rt6[133:139] == addr_rb_o)
		rb_o<=FW_rt6[4:131];	
	else if (FW_rt7[133:139] == addr_rb_o)
		rb_o<=FW_rt7[4:131];	
	else if (FW_rt2_o[133:139] == addr_rb_o)
		rb_o<=FW_rt2_o[4:131];
	else if (FW_rt3_o[133:139] == addr_rb_o)
		rb_o<=FW_rt3_o[4:131];
	else if (FW_rt4_o[133:139] == addr_rb_o)
		rb_o<=FW_rt4_o[4:131];	
	else if (FW_rt5_o[133:139] == addr_rb_o)
		rb_o<=FW_rt5_o[4:131];	
	else if (FW_rt6_o[133:139] == addr_rb_o)
		rb_o<=FW_rt6_o[4:131];	
	else if (FW_rt7_o[133:139] == addr_rb_o)
		rb_o<=FW_rt7_o[4:131];	
	else rb_o <= reg1[addr_rb_o];
	
	/*
	if (FW_rt2_o[133:139] == addr_rc_o)
		rc_o<=FW_rt2_o[4:131];
	else if (FW_rt3_o[133:139] == addr_rc_o)
		rc_o<=FW_rt3_o[4:131];
	else if (FW_rt4_o[133:139] == addr_rc_o)
		rc_o<=FW_rt4_o[4:131];	
	else if (FW_rt5_o[133:139] == addr_rc_o)
		rc_o<=FW_rt5_o[4:131];	
	else if (FW_rt6_o[133:139] == addr_rc_o)
		rc_o<=FW_rt6_o[4:131];	
	else if (FW_rt7_o[133:139] == addr_rc_o)
		rc_o<=FW_rt7_o[4:131];	
	else rc_o <= reg1[addr_rc_o];
	
	*/
	
	
	//if(!stall && stall1) ra_o<=FW_rt4[4:131];
	//else	ra_o <= reg1[addr_ra_o];
	
	
	
		
	end

	always_comb begin reg1[0]=0; reg1[1]=1; reg1[2]=2; reg1[3]=3; reg1[4]=4; reg1[5]=5; reg1[6]=6;reg1[7]=7;reg1[8]=8;
						 reg1[9]=9; reg1[10]=10; reg1[11]=11; reg1[12]=12; reg1[13]=13; reg1[14]=14; reg1[15]=15; reg1[16]=16;
						 reg1[20]=128'h41a00000; reg1[21]=128'h41a80000;reg1[22]=128'h41b80000;reg1[23]=128'h41b00000;reg1[24]=128'h41c00000;
						 reg1[25]=128'h41c80000; reg1[26]=128'h41d00000;reg1[27]=128'h41d80000;reg1[28]=128'h41e00000;reg1[29]=128'h41e80000;
						if (wr_en8)		reg1[addr_rt9] = rt;
						if (wr_en8_o)	reg1[addr_rt9_o] = rt_o;
						
						addr_rb = instruction_RegFetch_e[11:17];
						addr_ra = instruction_RegFetch_e[18:24];
						
						if(instruction_RegFetch_e[0:3] == 4'b1100 || instruction_RegFetch_e[0:3] == 4'b1110 ||instruction_RegFetch_e[0:3] == 4'b1111) begin	addr_rc = instruction_RegFetch_e[25:31];	addr_rt = instruction_RegFetch_e[4:10]; end 
														else begin	addr_rc = 7'bx;	addr_rt = instruction_RegFetch_e[25:31]; end						
						
						addr_ra_o = instruction_RegFetch_o[18:24];
						addr_rb_o = instruction_RegFetch_o[11:17];
						//addr_rc_o = instruction_RegFetch_o[18:24];
						addr_rt_o = instruction_RegFetch_o[25:31];
						
						
			end
			
	/////////////////////////Register file	


	
	
	
	
	
	
	
	

always_ff @(posedge clk) begin
	
		addr_match1= (addr_ra==addr_rt1 || addr_ra==addr_rt1_o || addr_rb==addr_rt1 || addr_rb==addr_rt1_o || addr_rc==addr_rt1 || addr_rc==addr_rt1_o) && stall_frominstrpair==0;
		addr_match2= (addr_ra==addr_rt2 || addr_ra==addr_rt2_o || addr_rb==addr_rt2 || addr_rb==addr_rt2_o || addr_rc==addr_rt2 || addr_rc==addr_rt2_o) && stall_frominstrpair==0;
		addr_match3= (addr_ra==addr_rt3 || addr_ra==addr_rt3_o || addr_rb==addr_rt3 || addr_rb==addr_rt3_o || addr_rc==addr_rt3 || addr_rc==addr_rt3_o) && stall_frominstrpair==0;
		addr_match4= (addr_ra==addr_rt4 || addr_ra==addr_rt4_o || addr_rb==addr_rt4 || addr_rb==addr_rt4_o || addr_rc==addr_rt4 || addr_rc==addr_rt4_o) && stall_frominstrpair==0;
		addr_match5= (addr_ra==addr_rt5 || addr_ra==addr_rt5_o || addr_rb==addr_rt5 || addr_rb==addr_rt5_o || addr_rc==addr_rt5 || addr_rc==addr_rt5_o) && stall_frominstrpair==0;
		addr_match6= (addr_ra==addr_rt6 || addr_ra==addr_rt6_o || addr_rb==addr_rt6 || addr_rb==addr_rt6_o || addr_rc==addr_rt6 || addr_rc==addr_rt6_o) && stall_frominstrpair==0;
		addr_match7= (addr_ra==addr_rt7 || addr_ra==addr_rt7_o || addr_rb==addr_rt7 || addr_rb==addr_rt7_o || addr_rc==addr_rt7 || addr_rc==addr_rt7_o) && stall_frominstrpair==0;
		
	end
	
	
	
always_comb 
	begin  delaypipe=1'b0; stall_onlyone=1'b0;
		
		
		
	
		if (instr1_is_even && instr2_is_even || !instr1_is_even && !instr2_is_even) begin delaypipe=1;stall_onlyone=1; end //Stall for only 1 cycle
	
	end
//////////////////////////////////Issue









///////////////////Even	
	always_ff @(posedge clk) begin
		rt1<=temp_packet; rt2<=rt1;rt3<=rt2;rt4<=rt3;rt5<=rt4;rt6<=rt5;rt7<=rt6; rt<=FW_rt7[4:131];
		rt2_Byte<=rt1_Byte; rt3_Byte<=rt2_Byte;rt2_SF2<=rt1_SF2; rt3_SF2<=rt2_SF2;
		rt2_SP1<=rt1_SP1;rt3_SP1<=rt2_SP1;rt4_SP1<=rt3_SP1;rt5_SP1<=rt4_SP1;
		rt2_SP2<=rt1_SP2;rt3_SP2<=rt2_SP2;rt4_SP2<=rt3_SP2;rt5_SP2<=rt4_SP2;rt6_SP2<=rt5_SP2;
		if (UnitID==1) begin rt1_SF1<=temp_packet;  end else rt1_SF1<=rt1_SF1;
		if (UnitID==2) begin rt1_SF2<=temp_packet; end else rt1_SF2<=rt1_SF2;
		if (UnitID==3) begin rt1_SP1<=temp_packet; end else rt1_SP1<=rt1_SP1;
		if (UnitID==4)begin rt1_SP2<=temp_packet; end else rt1_SP2<=rt1_SP2;
		if (UnitID==5) begin rt1_Byte<=temp_packet; end else rt1_Byte<=rt1_Byte;
	
	end
	
	
	 

	
		always_ff @(posedge clk) begin UnitID2<=UnitID; UnitID3<=UnitID2; UnitID4<=UnitID3; UnitID5<=UnitID4; UnitID6<=UnitID5; UnitID7<=UnitID6; end
		always_ff @(posedge clk) begin wr_en1<=wr_en; wr_en2<=wr_en1;wr_en3<=wr_en2;wr_en4<=wr_en3;wr_en5<=wr_en4;wr_en6<=wr_en5;wr_en7<=wr_en6;
			if(flush_3c3==1)	wr_en8<= 1'b0;
			else if (flush_for4cycles7==0) wr_en8<= 1'b1;
				else wr_en8<=wr_en7;

				end
		always_ff @(posedge clk) begin
		/*
		FW_rt2<= rt1_SF1;FW_rt3<=FW_rt2;FW_rt5<= FW_rt4;
		if (UnitID4==5) begin FW_rt4<=rt3_Byte;    FW_rt6<=FW_rt5; FW_rt7<=FW_rt6; end
		else if (UnitID4==2) begin FW_rt4<=rt3_SF2;   FW_rt6<=FW_rt5; FW_rt7<=FW_rt6; end
		else if (UnitID6==3) begin FW_rt6<=rt5_SP1;   FW_rt4<=FW_rt3; FW_rt7<=FW_rt6;end
		else if (UnitID7==4) begin FW_rt7<=rt6_SP2;   FW_rt4<=FW_rt3;FW_rt6<=FW_rt5; end
		else begin FW_rt4<=FW_rt3; FW_rt5<=FW_rt4;FW_rt6<=FW_rt5; FW_rt7<=FW_rt6;end
		*/
		/////////
		FW_rt3<= FW_rt2;FW_rt5<=FW_rt4;
		if (UnitID2==1) FW_rt2<= rt1_SF1; else FW_rt2<= FW_rt1;
		if (UnitID4==5) FW_rt4<=rt3_Byte; else if (UnitID4==2) FW_rt4<=rt3_SF2; else FW_rt4<= FW_rt3;
		if (UnitID6==3) FW_rt6<=rt5_SP1; else FW_rt6<= FW_rt5;
			
			if (UnitID7==4 && flush_3c2!=1 && flush_for4cycles6==1) FW_rt7<=rt6_SP2; 
			/*else if(flush_3c2==0 && flush_for4cycles6==1) FW_rt7<=FW_rt6;/////???
			else if (flush_for4cycles6==0 && flush_3c2==0) FW_rt7<=FW_rt6;
			else FW_rt7<= 143'bx;
			*/
			
			else if(flush_3c2==1 || (flush_3c1==1 && flush_for4cycles6==1)) FW_rt7<=143'bx;/////???
			//else if(flush_3c2==0 && flush_for4cycles6==1) FW_rt7<=143'bx;/////???
			//else if (flush_for4cycles6==0) FW_rt7<= FW_rt6;
			else FW_rt7<= FW_rt6;
		
		end
		///////////////////Even
		
		////flushing FW units after branch detected for 3 cycles
		always_comb begin
			if (br_taken5==1 ||br_taken6==1 ||br_taken7==1) flush_3c=1;
			else flush_3c=0;
		
		end
		
		
		always_ff @(posedge clk) begin flush_3c1<= flush_3c; flush_3c2<= flush_3c1; flush_3c3<= flush_3c2; end
		
		
		
		
		
		
		
		/////////////////Odd
		
	always_ff @(posedge clk) begin wr_en1_o<=wr_en_o; wr_en2_o<=wr_en1_o;wr_en3_o<=wr_en2_o;wr_en4_o<=wr_en3_o;wr_en5_o<=wr_en4_o;wr_en6_o<=wr_en5_o;wr_en7_o<=wr_en6_o;
		if (flush_3c3==1) wr_en8_o <= 1'b0;
			else wr_en8_o<=wr_en7_o; 
		
	end
	
	always_ff @(posedge clk) begin
		rt1_o<=temp_packet_o; rt2_o<=rt1_o;rt3_o<=rt2_o;rt4_o<=rt3_o;rt5_o<=rt4_o;rt6_o<=rt5_o;rt7_o<=rt6_o; rt_o<=FW_rt7_o[4:131];
		rt2_LS_o<=rt1_LS_o;rt3_LS_o<=rt2_LS_o;rt4_LS_o<=rt3_LS_o;rt5_LS_o<=rt4_LS_o;rt6_LS_o<=rt5_LS_o;
		rt2_Perm_o<=rt1_Perm_o; rt3_Perm_o<=rt2_Perm_o;
		rt2_BR_o<=rt1_BR_o; rt3_BR_o<=rt2_BR_o; rt4_BR_o<=rt3_BR_o; 
		if (UnitID_o==6) begin rt1_Perm_o<=temp_packet_o;  end else rt1_Perm_o<=rt1_Perm_o;
		if (UnitID_o==7) begin rt1_LS_o<=temp_packet_o;  end else rt1_LS_o<=rt1_LS_o;
		if (UnitID_o==8) rt1_BR_o<= temp_packet_o; else rt1_BR_o<=rt1_BR_o;
		//if (UnitID_o==6) begin rt1_Byte<=temp_packet_o; end else rt1_Byte<=rt1_Byte;
	
	end
	
	always_ff @(posedge clk) begin 
	PC1_o<=PC_o; PC2_o<=PC1_o; PC3_o<=PC2_o;
	branch_taken_2_o<=branch_taken_1_o; branch_taken_3_o<=branch_taken_2_o; branch_taken_3_o<=branch_taken_2_o; branch_taken_o<=branch_taken_3_o; 
	branch_taken_ahead1_o<=branch_taken_o; branch_taken_ahead2_o<=branch_taken_ahead1_o; branch_taken_ahead3_o<=branch_taken_ahead2_o;
	end
	
	//always_ff @(posedge clk) begin
	//	if (branch_taken_o==1) begin FW_rt3_o<=128'hx;FW_rt2_o<=128'hx; FW_rt1_o<=128'hx; end
	//	else begin FW_rt3_o<=FW_rt2_o;FW_rt2_o<=FW_rt1_o; FW_rt1_o<=temp_packet_o; end
	//end
	
	always_ff @(posedge clk) begin
	
		FW_rt5_o<=FW_rt4_o; //FW_rt3_o<=FW_rt2_o;FW_rt2_o<=FW_rt1_o; FW_rt1_o<=temp_packet_o;
		
		
		
		if (UnitID4_o==6) FW_rt4_o <= rt3_Perm_o; else if (UnitID4_o==8) FW_rt4_o <= rt3_BR_o; else FW_rt4_o <= FW_rt3_o;
		if (UnitID6_o==7)	FW_rt6_o <= rt5_LS_o; else FW_rt6_o <= FW_rt5_o;
		
		if (flush_3c2==1) FW_rt7_o<=143'bx;
		else FW_rt7_o<=FW_rt6_o;
		
		
		
		
	end
	
	always_ff @(posedge clk) begin UnitID2_o<=UnitID_o; UnitID3_o<=UnitID2_o; UnitID4_o<=UnitID3_o; UnitID5_o<=UnitID4_o; UnitID6_o<=UnitID5_o; UnitID7_o<=UnitID6_o; end
	
	always_ff @(posedge clk) begin
		if (branch_taken_ahead1_o==1 || branch_taken_ahead2_o==1 || branch_taken_ahead2_o==1 || branch_taken_o==1) branch_taken_3cycles_o=1; else branch_taken_3cycles_o=0;
	
	end
	
	/////////////////////odd
	
	
	
	
	
	
	
	
	
	////////////////////Even Comb
	always_comb begin   
	
		/////////////
		if (instruction[0:10]==11'b00011001000)///add halfword
		begin 
			UnitID=1; PC=PC+4;
			temp_rt[0:15]=ra[0:15] + rb[0:15];
			temp_rt[16:31]=ra[16:31] + rb[16:31];
			temp_rt[32:47]=ra[32:47] + rb[32:47];
			temp_rt[48:63]=ra[48:63] + rb[48:63];
			temp_rt[64:79]=ra[64:79] + rb[64:79];
			temp_rt[80:95]=ra[80:95] + rb[80:95];
			temp_rt[96:111]=ra[96:111] + rb[96:111];
			temp_rt[112:127]=ra[112:127] + rb[112:127];
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency	
		
		end
		/////////////
		
	
		/////////////
		else if (instruction[0:10]==11'b00011000000)///add word
		begin 
			UnitID=1; PC=PC+4;
			temp_rt[0:31]=ra[0:31] + rb[0:31];			
			temp_rt[32:63]=ra[32:63] + rb[32:63];			
			temp_rt[64:95]=ra[64:95] + rb[64:95];			
			temp_rt[96:127]=ra[96:127] + rb[96:127];	
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency	
		end
		/////////////
		
		
		/////////////
		else if (instruction[0:10]==11'b00001001000)///subtract from halfword
		begin 
			UnitID=1; PC=PC+4;
			temp_rt[0:15]=(~ra[0:15]) + rb[0:15] + 1;
			temp_rt[16:31]=(~ra[16:31]) + rb[16:31] + 1;
			temp_rt[32:47]=(~ra[32:47]) + rb[32:47] + 1;
			temp_rt[48:63]=(~ra[48:63]) + rb[48:63] + 1;
			temp_rt[64:79]=(~ra[64:79]) + rb[64:79] + 1;
			temp_rt[80:95]=(~ra[80:95]) + rb[80:95] + 1;
			temp_rt[96:111]=(~ra[96:111]) + rb[96:111] + 1;
			temp_rt[112:127]=(~ra[112:127]) + rb[112:127] + 1;	
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
			
		end
		
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00001000000)///Subtract from Word
		begin 
			UnitID=1; PC=PC+4;
			temp_rt[0:31]=(~ra[0:31]) + rb[0:31] +1;			
			temp_rt[32:63]=(~ra[32:63]) + rb[32:63] +1;			
			temp_rt[64:95]=(~ra[64:95]) + rb[64:95] +1;			
			temp_rt[96:127]=(~ra[96:127]) + rb[96:127] +1;		
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		
		/////////////
		else if (instruction[0:10]==11'b01101000000)///add Extended
		begin 
			UnitID=1; PC=PC+4;
			temp_rt[0:31]=ra[0:31] + rb[0:31] + temp_rt[31];			
			temp_rt[32:63]=ra[32:63] + rb[32:63] + temp_rt[63];			
			temp_rt[64:95]=ra[64:95] + rb[64:95] + temp_rt[95];			
			temp_rt[96:127]=ra[96:127] + rb[96:127] + temp_rt[127];
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end	
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b01101000001)///Subtract from Extended
		begin 
			UnitID=1; PC=PC+4;
			temp_rt[0:31]=(~ra[0:31]) + rb[0:31] + temp_rt[31];			
			temp_rt[32:63]=(~ra[32:63]) + rb[32:63] + temp_rt[63];			
			temp_rt[64:95]=(~ra[64:95]) + rb[64:95] + temp_rt[95];			
			temp_rt[96:127]=(~ra[96:127]) + rb[96:127] + temp_rt[127];	
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:10] == 11'b01101000010)///Carry Generate
		begin
			for(int j=0; j<128; j+=32)
				begin
					temp[0:32] = {1'b0, ra[j+:32]} + {1'b0, rb[j+:32]};
					temp_rt[j+:32] = {31'b0000000000000000000000000000000, temp[0]};
				end
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////

		/////////////
		else if (instruction[0:10] == 11'b00001000010)///Borrow Generate
		begin	
			for(int i=0; i<128; i+=32)
				begin	
					if(rb[i+:32] >= ra[i+:32])begin
						temp_rt[i+:32] = 1;end
					else
						begin temp_rt[i+:32] = 0;end
				end
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		
		/////////////
		/////////////
		else if (instruction[0:10]==11'b01111000100)///multiply
		begin 
			UnitID=1; PC=PC+4;
			temp_rt[0:31]=ra[16:31] * rb[16:31];			
			temp_rt[32:63]=ra[48:63] * rb[48:63];			
			temp_rt[64:95]=ra[80:95] * rb[80:95];			
			temp_rt[96:127]=ra[112:127] * rb[112:127];	
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:3]==4'b1100)///multiply and add
		begin
			UnitID=4; PC=PC+4;
			temp_rt[0:31]=(ra[16:31] * rb[16:31]) + rc[0:31];			
			temp_rt[32:63]=(ra[48:63] * rb[48:63]) + rc[32:63];			
			temp_rt[64:95]=(ra[80:95] * rb[80:95]) + rc[64:95];			
			temp_rt[96:127]=(ra[112:127] * rb[112:127]) + rc[96:127];
			temp_packet[0:3] = 4'b0100;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =7;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00011000001)///AND
		begin
			UnitID=1; PC=PC+4;
			for (int i=0;i<32; i++) temp_rt[i]=ra[i] && rb[i];	
			for (int i=0;i<32; i++) temp_rt[i+32]=ra[i+32] && rb[i+32];
			for (int i=0;i<32; i++) temp_rt[i+64]=ra[i+64] && rb[i+64];
			for (int i=0;i<32; i++) temp_rt[i+96]=ra[i+96] && rb[i+96];
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency	
		end
		/////////////
		
		
		/////////////
		else if (instruction[0:10]==11'b00001000001)///OR
		begin
			UnitID=1; PC=PC+4;
			for (int i=0;i<32; i++) temp_rt[i]=ra[i] || rb[i];
			for (int i=0;i<32; i++) temp_rt[i+32]=ra[i+32] || rb[i+32];
			for (int i=0;i<32; i++) temp_rt[i+64]=ra[i+64] || rb[i+64];
			for (int i=0;i<32; i++) temp_rt[i+96]=ra[i+96] || rb[i+96];
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency		
												
		end
		/////////////
		
		
		/////////////
		else if (instruction[0:10]==11'b00011000001)///Exclusive OR
		begin
			UnitID=1; PC=PC+4;
			for (int i=0;i<32; i++) temp_rt[i]=ra[i] ^ rb[i];	
			for (int i=0;i<32; i++) temp_rt[i+32]=ra[i+32] ^ rb[i+32];
			for (int i=0;i<32; i++) temp_rt[i+64]=ra[i+64] ^ rb[i+64];
			for (int i=0;i<32; i++) temp_rt[i+96]=ra[i+96] ^ rb[i+96];	
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		
		/////////////
		else if (instruction[0:10]==11'b00011001001)///NAND
		begin
			UnitID=1; PC=PC+4;
			for (int i=0;i<32; i++) temp_rt[i]=~(ra[i] && rb[i]);	
			for (int i=0;i<32; i++) temp_rt[i+32]=~(ra[i+32] && rb[i+32]);
			for (int i=0;i<32; i++) temp_rt[i+64]=~(ra[i+64] && rb[i+64]);
			for (int i=0;i<32; i++) temp_rt[i+96]=~(ra[i+96] && rb[i+96]);	
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00001001001)///NOR
		begin
			UnitID=1; PC=PC+4;
			for (int i=0;i<32; i++) temp_rt[i]=~(ra[i] || rb[i]);
			for (int i=0;i<32; i++) temp_rt[i+32]=~(ra[i+32] || rb[i+32]);
			for (int i=0;i<32; i++) temp_rt[i+64]=~(ra[i+64] || rb[i+64]);
			for (int i=0;i<32; i++) temp_rt[i+96]=~(ra[i+96] || rb[i+96]);
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
												
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b01010110100)///Count Ones in Bytes
		begin 
			UnitID=5; PC=PC+4;
			for (int i=0;i<122; i=i+8) begin count1=0; byte1=ra[i+:8];			
				for (int j=0;j<8; j++) begin				
					if (byte1[j]==1'b1) count1[0:7]=count1[0:7]+1'b1;
					else count1[0:7]=count1[0:7];			
				end
				temp_rt[i+:8]=count1;			
			end		
			temp_packet[0:3] = 4'b0101;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00001011111)///Shift Left Halfword
		begin 
			UnitID=2; PC=PC+4;
			temp_rt=ra;
			for (int i=0;i<=16; i++) begin if (rb[11:15]+i<16) temp_rt[i]=ra[rb[11:15]+i]; else temp_rt[i]<=0; end
			for (int i=0;i<=16; i++) begin if (rb[27:31]+i<16) temp_rt[i+16]=ra[rb[27:31]+i+16]; else temp_rt[i+16]=0; end
			for (int i=0;i<=16; i++) begin if (rb[43:47]+i<16) temp_rt[i+32]=ra[rb[43:47]+i+32]; else temp_rt[i+32]=0; end
			for (int i=0;i<=16; i++) begin if (rb[59:63]+i<16) temp_rt[i+48]=ra[rb[59:63]+i+48]; else temp_rt[i+48]=0; end
			for (int i=0;i<=16; i++) begin if (rb[75:79]+i<16) temp_rt[i+64]=ra[rb[75:79]+i+64]; else temp_rt[i+64]=0; end
			for (int i=0;i<=16; i++) begin if (rb[91:95]+i<16) temp_rt[i+80]=ra[rb[91:95]+i+80]; else temp_rt[i+80]=0; end
			for (int i=0;i<=16; i++) begin if (rb[107:111]+i<16) temp_rt[i+96]=ra[rb[107:111]+i+96]; else temp_rt[i+96]=0; end
			for (int i=0;i<=16; i++) begin if (rb[123:127]+i<16) temp_rt[i+112]=ra[rb[123:127]+i+112]; else temp_rt[i+112]=0; end
			temp_packet[0:3] = 4'b0010;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency	
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00001111111)///Shift Left Halfword Immediate
		begin temp_rt=ra;
			UnitID=2; PC=PC+4;
			for (int i=0;i<=16; i++) begin if (instruction[13:17]+i<16) temp_rt[i]=ra[instruction[13:17]+i]; else temp_rt[i]=0; end
			for (int i=0;i<=16; i++) begin if (instruction[13:17]+i<16) temp_rt[i+16]=ra[instruction[13:17]+i+16]; else temp_rt[i+16]=0; end
			for (int i=0;i<=16; i++) begin if (instruction[13:17]+i<16) temp_rt[i+32]=ra[instruction[13:17]+i+32]; else temp_rt[i+32]=0; end
			for (int i=0;i<=16; i++) begin if (instruction[13:17]+i<16) temp_rt[i+48]=ra[instruction[13:17]+i+48]; else temp_rt[i+48]=0; end
			for (int i=0;i<=16; i++) begin if (instruction[13:17]+i<16) temp_rt[i+64]=ra[instruction[13:17]+i+64]; else temp_rt[i+64]=0; end
			for (int i=0;i<=16; i++) begin if (instruction[13:17]+i<16) temp_rt[i+80]=ra[instruction[13:17]+i+80]; else temp_rt[i+80]=0; end
			for (int i=0;i<=16; i++) begin if (instruction[13:17]+i<16) temp_rt[i+96]=ra[instruction[13:17]+i+96]; else temp_rt[i+96]=0; end
			for (int i=0;i<=16; i++) begin if (instruction[13:17]+i<16) temp_rt[i+112]=ra[instruction[13:17]+i+112]; else temp_rt[i+112]=0; end
			temp_packet[0:3] = 4'b0010;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00001011011)///Shift Left Word
		begin temp_rt=ra;
			UnitID=2; PC=PC+4;
			for (int i=0;i<=32; i++) begin if (rb[26:31]+i<32) temp_rt[i]=ra[rb[26:31]+i]; else temp_rt[i]=0; end
			for (int i=0;i<=32; i++) begin if (rb[58:63]+i<32) temp_rt[i+32]=ra[rb[58:63]+i+32]; else temp_rt[i+32]=0; end
			for (int i=0;i<=32; i++) begin if (rb[90:95]+i<32) temp_rt[i+64]=ra[rb[90:95]+i+64]; else temp_rt[i+64]=0; end
			for (int i=0;i<=32; i++) begin if (rb[122:127]+i<32) temp_rt[i+96]=ra[rb[122:127]+i+96]; else temp_rt[i+96]=0; end
			temp_packet[0:3] = 4'b0010;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00001111011)///Shift Left Word Immediate
		begin temp_rt=ra;
			UnitID=2; PC=PC+4;
			for (int i=0;i<=32; i++) begin if (instruction[12:17]+i<32) temp_rt[i]=ra[instruction[12:17]+i]; else temp_rt[i]=0; end
			for (int i=0;i<=32; i++) begin if (instruction[12:17]+i<32) temp_rt[i+32]=ra[instruction[12:17]+i+32]; else temp_rt[i+32]=0; end
			for (int i=0;i<=32; i++) begin if (instruction[12:17]+i<32) temp_rt[i+64]=ra[instruction[12:17]+i+64]; else temp_rt[i+64]=0; end
			for (int i=0;i<=32; i++) begin if (instruction[12:17]+i<32) temp_rt[i+96]=ra[instruction[12:17]+i+96]; else temp_rt[i+96]=0; end
			temp_packet[0:3] = 4'b0010;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00001011100)///Rotate Halfword
		begin temp_rt=ra;
			UnitID=2; PC=PC+4;
			for (int i=0;i<=16; i++) begin if (rb[12:15]+i<16) temp_rt[i]=ra[rb[12:15]+i]; else temp_rt[i]=ra[rb[12:15]+i-16]; end
			for (int i=0;i<=16; i++) begin if (rb[28:31]+i<16) temp_rt[i+16]=ra[rb[28:31]+i+16]; else temp_rt[i+16]=ra[rb[28:31]+i+16-16]; end
			for (int i=0;i<=16; i++) begin if (rb[44:47]+i<16) temp_rt[i+32]=ra[rb[44:47]+i+32]; else temp_rt[i+32]=ra[rb[44:47]+i+32-16]; end
			for (int i=0;i<=16; i++) begin if (rb[60:63]+i<16) temp_rt[i+48]=ra[rb[60:63]+i+48]; else temp_rt[i+48]=ra[rb[60:63]+i+48-16]; end
			for (int i=0;i<=16; i++) begin if (rb[76:79]+i<16) temp_rt[i+64]=ra[rb[76:79]+i+64]; else temp_rt[i+64]=ra[rb[76:79]+i+64-16]; end
			for (int i=0;i<=16; i++) begin if (rb[92:95]+i<16) temp_rt[i+80]=ra[rb[92:95]+i+80]; else temp_rt[i+80]=ra[rb[92:95]+i+80-16]; end
			for (int i=0;i<=16; i++) begin if (rb[108:111]+i<16) temp_rt[i+96]=ra[rb[108:111]+i+96]; else temp_rt[i+96]=ra[rb[108:111]+i+96-16]; end
			for (int i=0;i<=16; i++) begin if (rb[124:127]+i<16) temp_rt[i+112]=ra[rb[124:127]+i+112]; else temp_rt[i+112]=ra[rb[124:127]+i+112-16]; end	
			temp_packet[0:3] = 4'b0010;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency			
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00001111100)///Rotate Halfword Immediate
		begin temp_rt=ra;
			UnitID=2; PC=PC+4;
			for (int i=0;i<=16; i++) begin if (instruction[14:17]+i<16) temp_rt[i]=ra[instruction[14:17]+i]; else temp_rt[i]=ra[instruction[14:17]+i-16]; end
			for (int i=0;i<=16; i++) begin if (instruction[14:17]+i<16) temp_rt[i+16]=ra[instruction[14:17]+i+16]; else temp_rt[i+16]=ra[instruction[14:17]+i+16-16]; end
			for (int i=0;i<=16; i++) begin if (instruction[14:17]+i<16) temp_rt[i+32]=ra[instruction[14:17]+i+32]; else temp_rt[i+32]=ra[instruction[14:17]+i+32-16]; end
			for (int i=0;i<=16; i++) begin if (instruction[14:17]+i<16) temp_rt[i+48]=ra[instruction[14:17]+i+48]; else temp_rt[i+48]=ra[instruction[14:17]+i+48-16]; end
			for (int i=0;i<=16; i++) begin if (instruction[14:17]+i<16) temp_rt[i+64]=ra[instruction[14:17]+i+64]; else temp_rt[i+64]=ra[instruction[14:17]+i+64-16]; end
			for (int i=0;i<=16; i++) begin if (instruction[14:17]+i<16) temp_rt[i+80]=ra[instruction[14:17]+i+80]; else temp_rt[i+80]=ra[instruction[14:17]+i+80-16]; end
			for (int i=0;i<=16; i++) begin if (instruction[14:17]+i<16) temp_rt[i+96]=ra[instruction[14:17]+i+96]; else temp_rt[i+96]=ra[instruction[14:17]+i+96-16]; end
			for (int i=0;i<=16; i++) begin if (instruction[14:17]+i<16) temp_rt[i+112]=ra[instruction[14:17]+i+112]; else temp_rt[i+112]=ra[instruction[14:17]+i+112-16]; end	
			temp_packet[0:3] = 4'b0010;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00001011000)///Rotate Word
		begin temp_rt=ra;
			UnitID=2; PC=PC+4;
			for (int i=0;i<=32; i++) begin if (rb[27:31]+i<32) temp_rt[i]=ra[rb[27:31]+i]; else temp_rt[i]=ra[rb[27:31]+i-32]; end
			for (int i=0;i<=32; i++) begin if (rb[59:63]+i<32) temp_rt[i+32]=ra[rb[59:63]+i+32]; else temp_rt[i+32]=ra[rb[59:63]+i+32-32]; end
			for (int i=0;i<=32; i++) begin if (rb[91:95]+i<32) temp_rt[i+64]=ra[rb[91:95]+i+64]; else temp_rt[i+64]=ra[rb[91:95]+i+64-32]; end
			for (int i=0;i<=32; i++) begin if (rb[123:127]+i<32) temp_rt[i+96]=ra[rb[123:127]+i+96]; else temp_rt[i+96]=ra[rb[123:127]+i+96-32]; end
			temp_packet[0:3] = 4'b0010;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b00001111000)///Rotate Word Immediate
		begin temp_rt=ra;
			UnitID=2; PC=PC+4;
			for (int i=0;i<=32; i++) begin if (instruction[13:17]+i<32) temp_rt[i]=ra[instruction[13:17]+i]; else temp_rt[i]=ra[instruction[13:17]+i-32]; end
			for (int i=0;i<=32; i++) begin if (instruction[13:17]+i<32) temp_rt[i+32]=ra[instruction[13:17]+i+32]; else temp_rt[i+32]=ra[instruction[13:17]+i+32-32]; end
			for (int i=0;i<=32; i++) begin if (instruction[13:17]+i<32) temp_rt[i+64]=ra[instruction[13:17]+i+64]; else temp_rt[i+64]=ra[instruction[13:17]+i+64-32]; end
			for (int i=0;i<=32; i++) begin if (instruction[13:17]+i<32) temp_rt[i+96]=ra[instruction[13:17]+i+96]; else temp_rt[i+96]=ra[instruction[13:17]+i+96-32]; end
			temp_packet[0:3] = 4'b0010;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency
		end
/////////////

/////////////
		else if (instruction[0:10]==11'b01111010000)///Compare Equal Byte
		begin
			UnitID=1; PC=PC+4;
			for(int i=0;i<128;i+=8)
			begin
				if (ra[i+:8]==rb[i+:8]) temp_rt[i+:8]=8'b11111111;
				else temp_rt[i+:8]=8'b00000000;
			end
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:7]==8'b01111110)///Compare Equal Byte Immediate
		begin
			UnitID=1; PC=PC+4;
			for(int i=0;i<128;i+=8)
			begin
				if (ra[i+:8]==instruction[10:17]) temp_rt[i+:8]=8'b11111111;
				else temp_rt[i+:8]=8'b00000000;
			end
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:10]==11'b01001010000)///Compare Greater Than Byte
		begin
			UnitID=1; PC=PC+4;
			for(int i=0;i<128;i+=8)
				begin
					if (ra[i+:8]>rb[i+:8]) temp_rt[i+:8]=8'b11111111;
				else temp_rt[i+:8]=8'b00000000;
			end
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:7]==8'b01001110)///Compare Greater Than Byte Immediate
		begin
			UnitID=1; PC=PC+4;
			for(int i=0;i<128;i+=8)
			begin
				if (ra[i+:8]>instruction[10:17]) temp_rt[i+:8]=8'b11111111;
				else temp_rt[i+:8]=8'b00000000;
			end
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		
		////////////
		
		else if ((instruction[0:7]==8'b00011101)||(instruction[0:7]==8'b01110100)||(instruction[0:7]==11'b00001101))///add halfword immediate
		begin
		for (int i=0;i<=5;i++) begin
		halfwordextend[i]=instruction[8]; end///use always comb block
		halfwordextend[6:15]=instruction[8:17];	
		
		if (instruction[0:7]==8'b00011101)///add halfword immediate
		begin		
				UnitID=1; PC=PC+4;
				temp_rt[0:15]=ra[0:15] + halfwordextend[0:15];
				temp_rt[16:31]=ra[16:31] + halfwordextend[0:15]; 
				temp_rt[32:47]=ra[32:47] + halfwordextend[0:15]; 
				temp_rt[48:63]=ra[48:63] + halfwordextend[0:15]; 
				temp_rt[64:79]=ra[64:79] + halfwordextend[0:15]; 
				temp_rt[80:95]=ra[80:95] + halfwordextend[0:15]; 
				temp_rt[96:111]=ra[96:111] + halfwordextend[0:15]; 
				temp_rt[112:127]=ra[112:127] + halfwordextend[0:15]; 
				temp_packet[0:3] = 4'b0001;//Unit ID
				temp_packet[4:131]= temp_rt[0:127];//Value in rt
				temp_packet[132]=1;//wr_en
				temp_packet[133:139] =addr_rt1;//address of rt
				temp_packet[140:142] =2;// Latency				
		end
		
		else if (instruction[0:7]==8'b01110100)///multiply immediate
		begin
			UnitID=1; PC=PC+4;
			temp_rt[0:31]=ra[16:31] * halfwordextend[0:15];			
			temp_rt[32:63]=ra[48:63] * halfwordextend[0:15];			
			temp_rt[64:95]=ra[80:95] * halfwordextend[0:15];			
			temp_rt[96:127]=ra[112:127] * halfwordextend[0:15];
			temp_packet[0:3] = 4'b0001;//Unit ID
				temp_packet[4:131]= temp_rt[0:127];//Value in rt
				temp_packet[132]=1;//wr_en
				temp_packet[133:139] =addr_rt1;//address of rt
				temp_packet[140:142] =2;// Latency
		end
		
		else if (instruction[0:7]==11'b00001101)///subtract from halfword immediate
		begin
			UnitID=1; PC=PC+4;
			temp_rt[0:15]=(~ra[0:15]) + halfwordextend[0:15] + 1;
			temp_rt[16:31]=(~ra[16:31]) + halfwordextend[0:15] + 1;
			temp_rt[32:47]=(~ra[32:47]) + halfwordextend[0:15] + 1;
			temp_rt[48:63]=(~ra[48:63]) + halfwordextend[0:15] + 1;
			temp_rt[64:79]=(~ra[64:79]) + halfwordextend[0:15] + 1;
			temp_rt[80:95]=(~ra[80:95]) + halfwordextend[0:15] + 1;
			temp_rt[96:111]=(~ra[96:111]) + halfwordextend[0:15] + 1;
			temp_rt[112:127]=(~ra[112:127]) + halfwordextend[0:15] + 1;
			temp_packet[0:3] = 4'b0001;//Unit ID
				temp_packet[4:131]= temp_rt[0:127];//Value in rt
				temp_packet[132]=1;//wr_en
				temp_packet[133:139] =addr_rt1;//address of rt
				temp_packet[140:142] =2;// Latency
		end
		
		end
		
		else if ((instruction[0:7]==8'b00011100)||(instruction[0:7]==8'b00001100))///add word immediate
		begin	
		
		for (int i=0;i<=21;i++) begin
		wordextend[i]=instruction[8]; end
		wordextend[22:31]=instruction[8:17];
		
		/////////////
		if (instruction[0:7]==8'b00011100)///add word immediate
		begin		
			UnitID=1; PC=PC+4;
			temp_rt[0:31]=ra[0:31] + wordextend[0:31];			
			temp_rt[32:63]=ra[32:63] + wordextend[0:31];			
			temp_rt[64:95]=ra[64:95] + wordextend[0:31];			
			temp_rt[96:127]=ra[96:127] + wordextend[0:31];	
				temp_packet[0:3] = 4'b0001;//Unit ID
				temp_packet[4:131]= temp_rt[0:127];//Value in rt
				temp_packet[132]=1;//wr_en
				temp_packet[133:139] =addr_rt1;//address of rt
				temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:7]==8'b00001100)///Subtract from Word Immediate
		begin
			UnitID=1; PC=PC+4;
			temp_rt[0:31]=(~ra[0:31]) + wordextend[0:31] +1;			
			temp_rt[32:63]=(~ra[32:63]) + wordextend[0:31] +1;			
			temp_rt[64:95]=(~ra[64:95]) + wordextend[0:31] +1;			
			temp_rt[96:127]=(~ra[96:127]) + wordextend[0:31] +1;	
				temp_packet[0:3] = 4'b0001;//Unit ID
				temp_packet[4:131]= temp_rt[0:127];//Value in rt
				temp_packet[132]=1;//wr_en
				temp_packet[133:139] =addr_rt1;//address of rt
				temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		
		
		
		end
		
		else if ((instruction[0:7]==8'b00010110)||(instruction[0:7]==8'b00000110)||(instruction[0:7]==8'b01000110))
		begin		
			
			wordextend[0:7]=instruction[10:17];
			wordextend[8:15]=instruction[10:17];
			wordextend[16:23]=instruction[10:17];
			wordextend[24:31]=instruction[10:17];
			
			/////////////
		 if (instruction[0:7]==8'b00010110)///AND Byte Immediate
		begin
			UnitID=1; PC=PC+4;
			for (int i=0;i<32; i++) temp_rt[i]=ra[i] && wordextend[i];
			for (int i=0;i<32; i++) temp_rt[i+32]=ra[i+32] && wordextend[i];
			for (int i=0;i<32; i++) temp_rt[i+64]=ra[i+64] && wordextend[i];
			for (int i=0;i<32; i++) temp_rt[i+96]=ra[i+96] && wordextend[i];
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
												
		end
		/////////////
		
		/////////////
		else if (instruction[0:7]==8'b00000110)///OR Byte Immediate
		begin
			UnitID=1; PC=PC+4;
			for (int i=0;i<32; i++) temp_rt[i]=ra[i] || wordextend[i];
			for (int i=0;i<32; i++) temp_rt[i+32]=ra[i+32] || wordextend[i];
			for (int i=0;i<32; i++) temp_rt[i+64]=ra[i+64] || wordextend[i];
			for (int i=0;i<32; i++) temp_rt[i+96]=ra[i+96] || wordextend[i];
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
												
		end
		/////////////
		
		/////////////
		else if (instruction[0:7]==8'b01000110)///EXOR Byte Immediate
		begin
			UnitID=1; PC=PC+4;
			for (int i=0;i<32; i++) temp_rt[i]=ra[i] ^ wordextend[i];
			for (int i=0;i<32; i++) temp_rt[i+32]=ra[i+32] ^ wordextend[i];
			for (int i=0;i<32; i++) temp_rt[i+64]=ra[i+64] ^ wordextend[i];
			for (int i=0;i<32; i++) temp_rt[i+96]=ra[i+96] ^ wordextend[i];
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
												
		end
		/////////////		
			
			end
		
		
		else if (instruction[0:10] == 11'b01011000100)///Floating Add
		begin
			UnitID=3; PC=PC+4;
			for(int i=0;i<127;i+=32)
			
			begin				
				q=$bitstoshortreal(ra[i+:32]);w=$bitstoshortreal(rb[i+:32]);
				temp1=q+w;			
				if (temp1<0) mag=-temp1; else mag=temp1;
				if (mag<$bitstoshortreal(32'h00800000)) temp_rt[i+:32]=0;
				else if (mag>=$bitstoshortreal(32'h7fffffff))temp_rt[i+:32]=32'h7fffffff;
				else temp_rt[i+:32]=$shortrealtobits(temp1);
			end		
			temp_packet[0:3] = 4'b0011;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =6;// Latency
		end
		///////
		
		/////////
		else if (instruction[0:10] == 11'b01011000101)///Floating Subtract
		begin
			UnitID=3; PC=PC+4;
			for(int i=0;i<127;i+=32)			
			begin				
				q=$bitstoshortreal(ra[i+:32]);w=$bitstoshortreal(rb[i+:32]);
				temp1=q-w;			
				if (temp1<0) mag=-temp1; else mag=temp1;
				if (mag<$bitstoshortreal(32'h00800000)) temp_rt[i+:32]=0;
				else if (mag>=$bitstoshortreal(32'h7fffffff))temp_rt[i+:32]=32'h7fffffff;
				else temp_rt[i+:32]=$shortrealtobits(temp1);
			end
			temp_packet[0:3] = 4'b0011;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =6;// Latency
		end
		//////////		
		
		/////////
		else if (instruction[0:10] == 11'b01011000110)///Floating Multiply
		begin
			UnitID=3; PC=PC+4;
			for(int i=0;i<127;i+=32)			
			begin
				
				q=$bitstoshortreal(ra[i+:32]);w=$bitstoshortreal(rb[i+:32]);
				temp1=q*w;			
				if (temp1<0) mag=-temp1; else mag=temp1;
				if (mag<=$bitstoshortreal(32'h00800000)) temp_rt[i+:32]=0;
				else if (mag>=$bitstoshortreal(32'h7fffffff))temp_rt[i+:32]=32'h7fffffff;
				else temp_rt[i+:32]=$shortrealtobits(temp1);
				
				if (temp_rt[i+:32]==32'h7fffffff) begin
					if ((ra[i]==1 && rb[i]==0) || (ra[i]==1 && rb[i]==0)) temp_rt[i+:32]=32'hffffffff;/////correct sign at output			
				end				
				
			end
			temp_packet[0:3] = 4'b0011;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =6;// Latency
		
		end
		//////////
		
		/////////
		else if (instruction[0:3] == 4'b1110)///Floating Multiply and Add
		begin
			UnitID=3; PC=PC+4;
			for(int i=0;i<127;i+=32)			
			begin
				
				q=$bitstoshortreal(ra[i+:32]);w=$bitstoshortreal(rb[i+:32]);e=$bitstoshortreal(rc[i+:32]);
				temp1=(q*w)+e;			
				if (temp1<0) mag=-temp1; else mag=temp1;
				if (mag<=$bitstoshortreal(32'h00800000)) temp_rt[i+:32]=0;
				else if (mag>=$bitstoshortreal(32'h7fffffff))temp_rt[i+:32]=32'h7fffffff;
				else temp_rt[i+:32]=$shortrealtobits(temp1);
				
				if (temp_rt[i+:32]==32'h7fffffff) begin
					if ((ra[i]==1 && rb[i]==0) || (ra[i]==1 && rb[i]==0)) temp_rt[i+:32]=32'hffffffff;/////correct sign at output			
				end					
			end
			temp_packet[0:3] = 4'b0011;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =6;// Latency
		
		end
		//////////
		
		/////////
		else if (instruction[0:3] == 4'b1111)///Floating Multiply and Subtract
		begin
			UnitID=3; PC=PC+4;
			for(int i=0;i<127;i+=32)			
			begin
				
				q=$bitstoshortreal(ra[i+:32]);w=$bitstoshortreal(rb[i+:32]);e=$bitstoshortreal(rc[i+:32]);
				temp1=(q*w)-e;			
				if (temp1<0) mag=-temp1; else mag=temp1;
				if (mag<=$bitstoshortreal(32'h00800000)) temp_rt[i+:32]=0;
				else if (mag>=$bitstoshortreal(32'h7fffffff))temp_rt[i+:32]=32'h7fffffff;
				else temp_rt[i+:32]=$shortrealtobits(temp1);
				
				if (temp_rt[i+:32]==32'h7fffffff) begin
					if ((ra[i]==1 && rb[i]==0) || (ra[i]==1 && rb[i]==0)) temp_rt[i+:32]=32'hffffffff;/////correct sign at output			
				end					
			end	
				temp_packet[0:3] = 4'b0011;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =6;// Latency
		end
		//////////
		
		/////////
		else if (instruction[0:10] == 11'b01111000010)///Floating Compare Equal
		begin
			UnitID=3; PC=PC+4;
			for(int i=0;i<127;i+=32)			
			begin				
				q=$bitstoshortreal(ra[i+:32]);w=$bitstoshortreal(rb[i+:32]);
				if (q==w)			
				temp_rt[i+:32]=32'hffffffff;
				else temp_rt[i+:32]=0;
			end	
				temp_packet[0:3] = 4'b0011;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =6;// Latency
		end
		//////////
		
		/////////
		else if (instruction[0:10] == 11'b01011000010)///Floating Compare Greater Than
		begin
			UnitID=3; PC=PC+4;
			for(int i=0;i<127;i+=32)			
			begin				
				q=$bitstoshortreal(ra[i+:32]);w=$bitstoshortreal(rb[i+:32]);
				if (q>w)			
				temp_rt[i+:32]=32'hffffffff;
				else temp_rt[i+:32]=0;
			end	
				temp_packet[0:3] = 4'b0011;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =6;// Latency
		end
		//////////	
		
		/////////
		else if (instruction[0:10]==11'b00011010011)///average bytes
		begin
			UnitID=5; PC=PC+4;
			for(int i = 0; i<127;i+=8) begin
			temp2[0:15] = {8'h00, ra[i+:8]} + {8'h00, rb[i+:8]} + 1;
			temp_rt[i+:8] = temp2[7:14];
			
			end
			
			temp_packet[0:3] = 4'b0101;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency
		end
		///////////
		
		///////////
	else if (instruction[0:10]==11'b00001010011)///Absolute Differences of Bytes
		begin
			UnitID=5; PC=PC+4;
			for (int i=0; i<128; i+=8) begin
				if(rb[i+:8] > ra[i+:8]) 	temp_rt[i+:8] = rb[i+:8] - ra[i+:8];
				else if (rb[i+:8] < ra[i+:8])	temp_rt[i+:8] = ra[i+:8] - rb[i+:8];				
				else temp_rt[i+:8]=0;
			end
			temp_packet[0:3] = 4'b0101;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency

		end
		/////////////
		
		/////////////
		
		else if(instruction[0:10]==11'b01001010011)///Sum Bytes into Halfwords
		begin	
			UnitID=5; PC=PC+4;
			temp_rt[0:15] = rb[0:7] + rb[8:15] + rb[16:23] + rb[24:31];
			temp_rt[16:31] = ra[0:7] + ra[8:15] + ra[16:23] + ra[24:31];
			temp_rt[32:47] = rb[32:39] + rb[40:47] + rb[48:55] + rb[56:63];
			temp_rt[48:63] = ra[32:39] + ra[40:47] + ra[48:55] + ra[56:63];
			temp_rt[64:79] = rb[64:71] + rb[72:79] + rb[80:87] + rb[88:95];
			temp_rt[80:95] = ra[64:71] + ra[72:79] + ra[80:87] + ra[88:95];
			temp_rt[96:111] = rb[96:103] + rb[104:111] + rb[112:119] + rb[120:127];
			temp_rt[112:127] = ra[96:103] + ra[104:111] + ra[112:119] + ra[120:127];
			temp_packet[0:3] = 4'b0101;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =4;// Latency
		end
		//////////////
		
		/////////////	
		else if(instruction[0:10] == 11'b01000000001)begin //No Operation (Execute)
			PC=PC+4;temp_packet =143'bx;
			
			if (instruction_RegFetch_e[0:10]==11'b00011001000 ||
		instruction_RegFetch_e[0:10]==11'b00011000000 ||
		instruction_RegFetch_e[0:10]==11'b00001001000 ||
		instruction_RegFetch_e[0:10]==11'b00001000000 ||
		instruction_RegFetch_e[0:10]==11'b01101000000 ||
		instruction_RegFetch_e[0:10]==11'b01101000001 ||
		instruction_RegFetch_e[0:10] == 11'b01101000010 ||
		instruction_RegFetch_e[0:10] == 11'b00001000010 ||
		instruction_RegFetch_e[0:10]==11'b01111000100 ||
		instruction_RegFetch_e[0:10]==11'b00011000001 ||
		instruction_RegFetch_e[0:10]==11'b00001000001 ||
		instruction_RegFetch_e[0:10]==11'b00011000001 ||
		instruction_RegFetch_e[0:10]==11'b00011001001 ||
		instruction_RegFetch_e[0:10]==11'b00001001001 ||
		instruction_RegFetch_e[0:10]==11'b01111010000 ||
		instruction_RegFetch_e[0:7]==8'b01111110 ||
		instruction_RegFetch_e[0:10]==11'b01001010000 ||
		instruction_RegFetch_e[0:7]==8'b01001110 ||
		instruction_RegFetch_e[0:7]==8'b00011101 ||
		instruction_RegFetch_e[0:7]==8'b01110100 ||
		instruction_RegFetch_e[0:7]==11'b00001101 ||
		instruction_RegFetch_e[0:7]==8'b00011100 ||
		instruction_RegFetch_e[0:7]==8'b00001100 ||
		instruction_RegFetch_e[0:7]==8'b00000110 ||
		instruction_RegFetch_e[0:7]==8'b01000110 ||
		instruction_RegFetch_e[0:8]==9'b010000011 ||
		instruction_RegFetch_e[0:8]==9'b010000010 ||
		instruction_RegFetch_e[0:8]==9'b010000001 ||
		instruction_RegFetch_e[0:6]==7'b0100001
		
		) temp_packet[140:142] =2;//latency
		
		else if (instruction_RegFetch_e[0:3]==4'b1100) 
		temp_packet[140:142] =7;//latency
		
		else if (instruction_RegFetch_e[0:10] == 11'b01011000100 ||
		instruction_RegFetch_e[0:10] == 11'b01011000101 ||
		instruction_RegFetch_e[0:10] == 11'b01011000110 ||
		instruction_RegFetch_e[0:3] == 4'b1110 ||
		instruction_RegFetch_e[0:3] == 4'b1111 ||
		instruction_RegFetch_e[0:10] == 11'b01111000010 ||	
		instruction_RegFetch_e[0:10] == 11'b01011000010
		
		) temp_packet[140:142] =6;//latency
		
		else if (instruction_RegFetch_e[0:10]==11'b01010110100 ||
		instruction_RegFetch_e[0:10]==11'b00001011111 ||
		instruction_RegFetch_e[0:10]==11'b00001111111 ||
		instruction_RegFetch_e[0:10]==11'b00001011011 ||
		instruction_RegFetch_e[0:10]==11'b00001111011 ||
		instruction_RegFetch_e[0:10]==11'b00001011100 ||
		instruction_RegFetch_e[0:10]==11'b00001111100 ||
		instruction_RegFetch_e[0:10]==11'b00001011000 ||
		instruction_RegFetch_e[0:10]==11'b00001111000 ||
		instruction_RegFetch_e[0:10]==11'b00011010011 ||
		instruction_RegFetch_e[0:10]==11'b00001010011 ||
		instruction_RegFetch_e[0:10]==11'b01001010011
		) temp_packet[140:142] =4;//latency
		
		else temp_packet[140:142] =3'bx;
		
			
			
			//no operation
		end
		////////////
		
		/////////////
		else if (instruction[0:8]==9'b010000011)///Immediate Load Halfword
		begin
			UnitID=1; PC=PC+4;
			temp2[0:15] = instruction[9:24];
			for(int i=0;i<127;i+=16)
				begin
					temp_rt[i+:16] = temp2[0:15];
				end
				temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:8]==9'b010000010)///Immediate Load Halfword Upper
		begin
			UnitID=1; PC=PC+4;
			temp2[0:15] = instruction[9:24];
			tempword[0:31] = {temp2, 16'h0000};
			for(int i=0;i<127;i+=32)
				begin
					temp_rt[i+:32] = tempword[0:31];
				end
				temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		/////////////
		else if (instruction[0:8]==9'b010000001)///Immediate Load Word
		begin
			UnitID=1; PC=PC+4;
			for(int i=0;i<16;i++)	tempword[i] = instruction[9];			
			tempword[16:31] = instruction[9:24];		
			for(int j=0;j<127;j+=32)	temp_rt[j+:32] = tempword[0:31];
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		/////////////
		else if(instruction[0:6]==7'b0100001)///Immediate Load Address
		begin
			UnitID=1; PC=PC+4;
			tempword[0:31] = {14'b00000000000000, instruction[7:24]};
			for(int i=0;i<127;i+=32)	temp_rt[i+:32] = tempword[0:31];
			temp_packet[0:3] = 4'b0001;//Unit ID
			temp_packet[4:131]= temp_rt[0:127];//Value in rt
			temp_packet[132]=1;//wr_en
			temp_packet[133:139] =addr_rt1;//address of rt
			temp_packet[140:142] =2;// Latency
		end
		/////////////
		
		
		
		
		
		
		//////////////
		else begin 
		UnitID=4'bx;
		temp_rt=0;temp_packet=143'bx; end
		
	end
	//////////////
	
	
	assign wr_en=temp_packet[132];
	//////////////////////////////Even Comb
	
	
	
	
	
	
	
	
	
	
	
	////////////////////////////Odd Comb
	always_comb
begin	LSLR=32'h00007fff; PC_o=32'h00001111; branch_taken_1_o=1'b0; miss_packet=0; Finish=0; br_taken=0;
		for(int i=0; i<127 ; i+=8)
		tp_o[i+:8] = mem[LSA_o+(i/8)];
	

	if(instruction_o[0:7] == 8'b00110100)begin //Load Quadword(d-form)
		UnitID_o=7; PC_o=PC_o+4;branch_taken_1_o=0;
		for(int i=0; i<18 ; i++)
			temp1_o[i] = instruction_o[8];
		temp1_o[18:27] = instruction_o[8:17];
		temp2_o[0:31] = {temp1_o[0:27], 4'b0000};
		temp3_o[0:31] = temp2_o[0:31] + ra_o[0:31];
		LSA_o[0:31] = temp3_o[0:31] & (LSLR) & (32'hfffffff0); 	//LSA_o[0:31] =32'h000077e0;
		for(int i=0; i<127 ; i+=8)
		temp_rt_o[i+:8] = mem[LSA_o+(i/8)];
		temp_packet_o[0:3] = 4'b0111;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=1;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =6;// Latency
	end
	////////////
	
	/////////////
	else if(instruction_o[0:7] == 8'b00100100)begin //Store Quadword(d-form)
		UnitID_o=7; PC_o=PC_o+4;
		for(int i=0; i<18 ; i++)
			temp1_o[i] = instruction_o[8];
		temp1_o[18:27] = instruction_o[8:17];
		temp2_o[0:31] = {temp1_o[0:27], 4'b0000};
		temp3_o[0:31] = temp2_o[0:31] + ra_o[0:31];
		LSA_o[0:31] = temp3_o[0:31] & (LSLR) & (32'hfffffff0); 
		//LSA_o = 400;
		
		//Memory[LSA5_o]=1;
		
		
		
		
		
		//temp_rt_o=100;/////random value store
		
		/*for(int i=0; i<127 ; i+=8)
		mem[LSA_o+(i/8)] = temp_rt_o[i+:8];
		*/
		/*temp_packet_o[0:3] = 4'b0111;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=0;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =6;// Latency
		*/
		//mem[17824]=35;
		end
	/////////////
		
	/////////////	
	else if(instruction_o[0:10] == 11'b00111000100)begin //Load Quadword (x-form)
		UnitID_o=7; PC_o=PC_o+4;
		temp3_o[0:31] = rb_o[0:31] + ra_o[0:31];
		LSA_o[0:31] = temp3_o[0:31] & (LSLR) & (32'hfffffff0);	
		for(int i=0; i<127 ; i+=8)
		temp_rt_o[i+:8] = mem[LSA_o+(i/8)];
		temp_packet_o[0:3] = 4'b0111;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=1;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =6;// Latency
		
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:10] == 11'b00101000100)begin //Store Quadword (x-form)
		UnitID_o=7; PC_o=PC_o+4;
		temp3_o[0:31] = rb_o[0:31] + ra_o[0:31];
		LSA_o[0:31] = temp3_o[0:31] & (LSLR) & (32'hfffffff0);	
		for(int i=0; i<127 ; i+=8)
		mem[LSA_o+(i/8)] = temp_rt_o[i+:8];
		temp_packet_o[0:3] = 4'b0111;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=0;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =6;// Latency
	end
	////////////
	
	//////////////
	else if(instruction_o[0:8] == 9'b001100111)begin //Load Quadword Instruction Relative (a-form)
		UnitID_o=7; PC_o=PC_o+4;
		for(int i=0; i<14 ; i++)
			temp_o[i] = instruction_o[9];
		temp_o[14:29] = instruction_o[9:24];
		temp2_o[0:31] = {temp_o[0:27], 2'b00};
		temp3_o[0:31] = PC_o[0:31] + temp2_o[0:31];
		LSA_o[0:31] = temp3_o[0:31] & (LSLR) & (32'hfffffff0);	
		for(int i=0; i<127 ; i+=8)
		temp_rt_o[i+:8] = mem[LSA_o+(i/8)];
		temp_packet_o[0:3] = 4'b0111;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=1;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =6;// Latency
	end
	////////////
	
	//////////////
	else if(instruction_o[0:8] == 9'b001000111)begin //Store Quadword Instruction Relative (a-form)
		UnitID_o=7; PC_o=PC_o+4;
		for(int i=0; i<14 ; i++)
			temp_o[i] = instruction_o[9];
		temp_o[14:29] = instruction_o[9:24];
		temp2_o[0:31] = {temp_o[0:27], 2'b00};
		temp3_o[0:31] = PC_o[0:31] + temp2_o[0:31];
		LSA_o[0:31] = temp3_o[0:31] & (LSLR) & (32'hfffffff0);	
		for(int i=0; i<127 ; i+=8)
		mem[LSA_o+(i/8)] = temp_rt_o[i+:8];
		temp_packet_o[0:3] = 4'b0111;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=0;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =6;// Latency
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:10] == 11'b00111011011)begin //Shift Left Quadword by Bits
		UnitID_o=6; PC_o=PC_o+4;
		temp1_o=rb_o[29:31];
		for (int i=0;i<128; i++) 
		begin 
			if (i+temp1_o<128) temp_rt_o[i]=ra_o[i+temp1_o];
			else temp_rt_o[i]=0;
		end
		temp_packet_o[0:3] = 4'b0110;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=1;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =4;// Latency
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:10] == 11'b00111011111)begin //Shift Left Quadword by Bytes
		UnitID_o=6; PC_o=PC_o+4;
		temp1_o=rb_o[27:31];
		for (int i=0;i<127; i+=8) 
		begin 
			if (i+temp1_o*8<127) temp_rt_o[i+:8]=ra_o[(i+temp1_o*8)+:8];
			else temp_rt_o[i+:8]=0;
		end
		temp_packet_o[0:3] = 4'b0110;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=1;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =4;// Latency
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:10] == 11'b00111011100)begin //Rotate Quadword by Bytes
		UnitID_o=6; PC_o=PC_o+4;
		temp1_o=rb_o[28:31];
		for (int i=0;i<127; i+=8) 
		begin 
			if (i+temp1_o*8<127) temp_rt_o[i+:8]=ra_o[(i+temp1_o*8)+:8];
			else temp_rt_o[i+:8]=ra_o[(i+temp1_o*8-16*8)+:8];
		end
		temp_packet_o[0:3] = 4'b0110;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=1;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =4;// Latency
		//temp_packet_o = 143'bx;
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:8] == 9'b001100100)begin //Branch Relative
		UnitID_o=8; 
		for(int i=0; i<14 ; i++)
			temp_o[i] = instruction_o[9];
		temp_o[14:29] = instruction_o[9:24];
		temp2_o[0:31] = {temp_o[0:29], 2'b00};
		PC_o[0:31] = (PC_o[0:31] + temp2_o[0:31]) & LSLR;
		temp_packet_o[0:3] = 4'b1000;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=0;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =4;// Latency
		temp_packet_o = 143'bx;
		
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:8] == 9'b001100000)begin //Branch Absolute
		UnitID_o=8; 
		for(int i=0; i<14 ; i++)
			temp_o[i] = instruction_o[9];
		temp_o[14:29] = instruction_o[9:24];
		temp2_o[0:31] = {temp_o[0:29], 2'b00};
		br_add = temp2_o;
		br_taken=1;
		
		//LSA_o[0:31] = temp2_o[0:31] & LSLR;
		/*temp_packet_o[0:3] = 4'b1000;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=0;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =4;// Latency*/
		temp_packet_o = 143'bx;
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:8] == 9'b001100010)begin //Branch Absolute and Set Link
		UnitID_o=8; 
		for(int i=0; i<14 ; i++)
			temp_o[i] = instruction_o[9];
		temp_o[14:29] = instruction_o[9:24];
		temp2_o[0:31] = {temp_o[0:29], 2'b00};
		PC_o[0:31] = temp2_o[0:31] & LSLR;
		temp_rt_o[0:31] = (PC_o[0:31] + 4) & LSLR;
		temp_rt_o[32:127]=0;
		temp_packet_o[0:3] = 4'b1000;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=1;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =4;// Latency		
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:8] == 9'b001000010)begin //Branch If Not Zero Word
		UnitID_o=8; 
		if (temp_rt_o[0:31]!=0)
		begin
			for(int i=0; i<14 ; i++)
				temp_o[i] = instruction_o[9];
			temp_o[14:29] = instruction_o[9:24];
			temp2_o[0:31] = {temp_o[0:29], 2'b00};
			PC_o[0:31] = (PC_o[0:31] + temp2_o[0:31]) & LSLR & 32'hfffffffc;
			
		end
		else PC_o[0:31] = (PC_o[0:31] + 4) & LSLR;
		temp_packet_o[0:3] = 4'b1000;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=0;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =4;// Latency
		
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:8] == 9'b001000000)begin //Branch If Zero Word
		UnitID_o=8; 
		if (temp_rt_o[0:31]==0)
		begin
			for(int i=0; i<14 ; i++)
				temp_o[i] = instruction_o[9];
			temp_o[14:29] = instruction_o[9:24];
			temp2_o[0:31] = {temp_o[0:29], 2'b00};
			PC_o[0:31] = (PC_o[0:31] + temp2_o[0:31]) & LSLR & 32'hfffffffc;
			
		end
		else PC_o[0:31] = (PC_o[0:31] + 4) & LSLR;
		temp_packet_o[0:3] = 4'b1000;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=0;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =4;// Latency
		
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:8] == 9'b001000110)begin //Branch If Not Zero Halfword
		UnitID_o=8; 
		if (temp_rt_o[16:31]!=0)
		begin
			for(int i=0; i<14 ; i++)
				temp_o[i] = instruction_o[9];
			temp_o[14:29] = instruction_o[9:24];
			temp2_o[0:31] = {temp_o[0:29], 2'b00};
			PC_o[0:31] = (PC_o[0:31] + temp2_o[0:31]) & LSLR & 32'hfffffffc;
			
		end
		else PC_o[0:31] = (PC_o[0:31] + 4) & LSLR;
		temp_packet_o[0:3] = 4'b1000;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=0;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =4;// Latency
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:8] == 9'b001000100)begin //Branch If Zero Halfword
		UnitID_o=8; 
		if (temp_rt_o[16:31]==0)
		begin
			for(int i=0; i<14 ; i++)
				temp_o[i] = instruction_o[9];
			temp_o[14:29] = instruction_o[9:24];
			temp2_o[0:31] = {temp_o[0:29], 2'b00};
			PC_o[0:31] = (PC_o[0:31] + temp2_o[0:31]) & LSLR & 32'hfffffffc;
			
		end
		else PC_o[0:31] = (PC_o[0:31] + 4) & LSLR;
		temp_packet_o[0:3] = 4'b1000;//Unit ID
		temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=0;//wr_en
		temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		temp_packet_o[140:142] =4;// Latency
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:10] == 11'b00000000001)begin //No Operation (Load)
		PC_o=PC_o+4; temp_packet_o=143'bx;
		
		if (instruction_RegFetch_o[0:7] == 8'b00110100 ||
		instruction_o[0:7] == 8'b00100100 ||
		instruction_o[0:10] == 11'b00111000100 ||
		instruction_o[0:10] == 11'b00101000100 ||
		instruction_o[0:8] == 9'b001100111 ||
		instruction_o[0:8] == 9'b001000111
		
		
		
		) temp_packet_o[140:142]= 6;
		
		else if (instruction_RegFetch_o[0:10] == 11'b00111011011 ||
		instruction_o[0:10] == 11'b00111011111 ||
		instruction_o[0:10] == 11'b00111011100 ||
		instruction_o[0:8] == 9'b001100100 ||
		instruction_o[0:8] == 9'b001100000 ||
		instruction_o[0:8] == 9'b001100010 ||
		instruction_o[0:8] == 9'b001000010 ||
		instruction_o[0:8] == 9'b001000000 ||
		instruction_o[0:8] == 9'b001000110 ||
		instruction_o[0:8] == 9'b001000100
				
		) temp_packet_o[140:142]= 4;
		
		else temp_packet_o[140:142]= 3'bx;;
		
		
		
		//no operation
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:10] == 11'b01111011000)begin //Halt If Equal
		if (ra_o[0:31] == rb_o[0:31]) Finish=1;
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:7] == 8'b01111111)begin //Halt If Equal Immediate
		for(int i=0; i<22 ; i++)
				temp2_o[i] = instruction_o[8];
			temp2_o[22:31] = instruction_o[8:17];
		if (ra_o[0:31] == temp2_o[0:31]) Finish=1;
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:10] == 11'b01001011000)begin //Halt If Greater Than
		if (ra_o[0:31] > rb_o[0:31]) Finish=1;
	end
	////////////
	
	/////////////	
	else if(instruction_o[0:7] == 8'b01001111)begin //Halt If Greater Than Immediate
		for(int i=0; i<22 ; i++)
				temp2_o[i] = instruction_o[8];
			temp2_o[22:31] = instruction_o[8:17];
		if (ra_o[0:31] > temp2_o[0:31]) Finish=1;
	end
	/////////////
	
	
	
	else if(instruction_o[0:10] == 11'b01011011000)//Instruction miss
		begin
			//LSA5_o = LSA_o[0:31] & 32'h00007ff0;
			
			miss_packet=1;
			//temp_packet_o[4:131]= temp_rt_o[0:127];
			//temp_packet_o[0:3] = 4'b1000;//Unit ID
		//temp_packet_o[4:131]= temp_rt_o[0:127];//Value in rt_o
		temp_packet_o[132]=0;//wr_en
		//temp_packet_o[133:139] =addr_rt1_o;//address of rt_o
		//temp_packet_o[140:142] =4;// Latency
		end
	
	
	
	
	
	
	else begin temp_rt_o = 0; branch_taken_1_o=0; UnitID_o=4'bx;temp_packet_o=143'bx;     end
end

	assign wr_en_o=temp_packet_o[132];
///////////////////////////////////////////Odd comb
		
			
	
endmodule






















module testbench();



logic clk, incrpc;



initial begin clk 	= 0; incrpc=0; end
always #5 clk  = ~clk;
always #10 incrpc=1;
fetch dut(clk,incrpc);



initial begin
      //$monitor($time,, "instruction_RegFetch_e = %b , instruction_RegFetch_o = %b", instruction_RegFetch_e, instruction_RegFetch_o);
	  
	 
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk); @(posedge clk); @(posedge clk);	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	   @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  @(posedge clk);
	  $finish;
	end

endmodule


	  
	  


