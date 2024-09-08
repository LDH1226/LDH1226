// CAL.v

module cal(

//input
input wire [5:0] number,   
input wire [2:0] op, //3’b000:’0’, 3’b001:’+’, 3’b010:’-’, 3’b011:’*’, 3’b100:’/’
input wire eq, //1’b1:’=’ 
input wire reset,
input wire enter,
input wire clk,

//output
output wire [3:0] op_out_led,
output wire [6:0] num_led0, //segment0
output wire [6:0] num_led1, //segment1
output wire [6:0] num_led2, //segment2
output wire [6:0] num_led3, //segment3
output wire [6:0] num_led4, //segment4
output wire [6:0] num_led5, //segment5

output wire [2:0] state_check
);

parameter INITIAL = 3'b000, INI_NUM=3'b001, OPERATE=3'b010, NEXT_NUM = 3'b011, RESULT=3'b100; //파라미터 설정

reg [2:0] state;
reg [2:0] next_state; //state 5개.
reg [20:0] result;
reg a;

always@*begin // state decision
	case({state,op,eq,enter})
		{INITIAL, 3'b000, 1'b0, 1'b0} :next_state =  INITIAL;
		{INITIAL, 3'b001, 1'b0, 1'b0} :next_state =  INITIAL;
		{INITIAL, 3'b010, 1'b0, 1'b0} :next_state =  INITIAL;
		{INITIAL, 3'b011, 1'b0, 1'b0} :next_state =  INITIAL;
		{INITIAL, 3'b100, 1'b0, 1'b0} :next_state =  INITIAL;
		{INITIAL, 3'b000, 1'b1, 1'b0} :next_state =  INITIAL;
		{INITIAL, 3'b001, 1'b1, 1'b0} :next_state =  INITIAL;
		{INITIAL, 3'b010, 1'b1, 1'b0} :next_state =  INITIAL;
		{INITIAL, 3'b011, 1'b1, 1'b0} :next_state =  INITIAL;
		{INITIAL, 3'b100, 1'b1, 1'b0} :next_state =  INITIAL; 
			
		// enter 누르기전까지는 무조건 INITIAL
		{INITIAL, 3'b000, 1'b0, 1'b1} :next_state =  INI_NUM;
		{INITIAL, 3'b001, 1'b0, 1'b1} :next_state =  INITIAL;
		{INITIAL, 3'b010, 1'b0, 1'b1} :next_state =  INITIAL;
		{INITIAL, 3'b011, 1'b0, 1'b1} :next_state =  INITIAL;
		{INITIAL, 3'b100, 1'b0, 1'b1} :next_state =  INITIAL;
		{INITIAL, 3'b000, 1'b1, 1'b1} :next_state =  INITIAL;
		{INITIAL, 3'b001, 1'b1, 1'b1} :next_state =  INITIAL;
		{INITIAL, 3'b010, 1'b1, 1'b1} :next_state =  INITIAL;
		{INITIAL, 3'b011, 1'b1, 1'b1} :next_state =  INITIAL;
		{INITIAL, 3'b100, 1'b1, 1'b1} :next_state =  INITIAL;
		{INI_NUM, 3'b000, 1'b0, 1'b0} :next_state = INI_NUM;
		{INI_NUM, 3'b001, 1'b0, 1'b0} :next_state = INI_NUM;
		{INI_NUM, 3'b010, 1'b0, 1'b0} :next_state = INI_NUM;
		{INI_NUM, 3'b011, 1'b0, 1'b0} :next_state = INI_NUM;
		{INI_NUM, 3'b100, 1'b0, 1'b0} :next_state = INI_NUM;
		{INI_NUM, 3'b000, 1'b1, 1'b0} :next_state = INI_NUM;
		{INI_NUM, 3'b001, 1'b1, 1'b0} :next_state = INI_NUM;
		{INI_NUM, 3'b010, 1'b1, 1'b0} :next_state = INI_NUM;
		{INI_NUM, 3'b011, 1'b1, 1'b0} :next_state = INI_NUM;
		{INI_NUM, 3'b100, 1'b1, 1'b0} :next_state = INI_NUM; 
	
		// enter 까지 본인 state
		{INI_NUM, 3'b000, 1'b0, 1'b1} :next_state = INI_NUM;
		{INI_NUM, 3'b001, 1'b0, 1'b1} :next_state = OPERATE;
		{INI_NUM, 3'b010, 1'b0, 1'b1} :next_state = OPERATE;
		{INI_NUM, 3'b011, 1'b0, 1'b1} :next_state = OPERATE;
		{INI_NUM, 3'b100, 1'b0, 1'b1} :next_state = OPERATE;
		{INI_NUM, 3'b000, 1'b1, 1'b1} :next_state = INITIAL; 로 보내기 우선
		{INI_NUM, 3'b001, 1'b1, 1'b1} :next_state = INITIAL;
		{INI_NUM, 3'b010, 1'b1, 1'b1} :next_state = INITIAL;
		{INI_NUM, 3'b011, 1'b1, 1'b1} :next_state = INITIAL;
		{INI_NUM, 3'b100, 1'b1, 1'b1} :next_state = INITIAL;
	
		{NEXT_NUM, 3'b000, 1'b0, 1'b0} :next_state = NEXT_NUM;
		{NEXT_NUM, 3'b000, 1'b1, 1'b0} :next_state = NEXT_NUM;
		{NEXT_NUM, 3'b001, 1'b0, 1'b0} :next_state = NEXT_NUM;
		{NEXT_NUM, 3'b001, 1'b1, 1'b0} :next_state = NEXT_NUM;
		{NEXT_NUM, 3'b010, 1'b0, 1'b0} :next_state = NEXT_NUM;
		{NEXT_NUM, 3'b010, 1'b1, 1'b0} :next_state = NEXT_NUM;
		{NEXT_NUM, 3'b011, 1'b0, 1'b0} :next_state = NEXT_NUM;
		{NEXT_NUM, 3'b011, 1'b1, 1'b0} :next_state = NEXT_NUM;
		{NEXT_NUM, 3'b100, 1'b0, 1'b0} :next_state = NEXT_NUM;
		{NEXT_NUM, 3'b100, 1'b1, 1'b0} :next_state = NEXT_NUM;
		{NEXT_NUM, 3'b000, 1'b1, 1'b1} :next_state = RESULT;
		{NEXT_NUM, 3'b001, 1'b0, 1'b1} :next_state = OPERATE;
		{NEXT_NUM, 3'b010, 1'b0, 1'b1} :next_state = OPERATE;
		{NEXT_NUM, 3'b011, 1'b0, 1'b1} :next_state = OPERATE;
		{NEXT_NUM, 3'b100, 1'b0, 1'b1} :next_state = OPERATE;
 
		{OPERATE, 3'b000, 1'b0, 1'b0} :next_state = OPERATE;       
		{OPERATE, 3'b000, 1'b0, 1'b1} :next_state = NEXT_NUM;      
		{OPERATE, 3'b000, 1'b1, 1'b1} :next_state = INITIAL;
		{OPERATE, 3'b001, 1'b0, 1'b0} :next_state = OPERATE;     
		{OPERATE, 3'b001, 1'b0, 1'b1} :next_state = NEXT_NUM ;              
		{OPERATE, 3'b001, 1'b1, 1'b0} :next_state = OPERATE;                  
		{OPERATE, 3'b001, 1'b1, 1'b1} :next_state = INITIAL;       
		{OPERATE, 3'b010, 1'b0, 1'b0} :next_state = OPERATE;
		{OPERATE, 3'b010, 1'b0, 1'b1} :next_state = NEXT_NUM;
		{OPERATE, 3'b010, 1'b1, 1'b0} :next_state = OPERATE;
		{OPERATE, 3'b010, 1'b1, 1'b1} :next_state = INITIAL;
		{OPERATE, 3'b011, 1'b0, 1'b0} :next_state = OPERATE;
		{OPERATE, 3'b011, 1'b0, 1'b1} :next_state = NEXT_NUM;
		{OPERATE, 3'b011, 1'b1, 1'b0} :next_state = OPERATE;
		{OPERATE, 3'b011, 1'b1, 1'b1} :next_state = INITIAL;          
		{OPERATE, 3'b100, 1'b0, 1'b0} :next_state = OPERATE;
		{OPERATE, 3'b100, 1'b0, 1'b1} :next_state = NEXT_NUM;
		{OPERATE, 3'b100, 1'b1, 1'b0} :next_state = OPERATE;
		{OPERATE, 3'b100, 1'b1, 1'b1} :next_state = INITIAL;
	
		{RESULT, 3'b000, 1'b0, 1'b0} : next_state =RESULT;
		{RESULT, 3'b000, 1'b1, 1'b0} : next_state =RESULT;
		{RESULT, 3'b001, 1'b0, 1'b0} : next_state =RESULT;
		{RESULT, 3'b001, 1'b1, 1'b0} : next_state =RESULT;
		{RESULT, 3'b010, 1'b0, 1'b0} : next_state =RESULT;
		{RESULT, 3'b010, 1'b1, 1'b0} : next_state =RESULT;
		{RESULT, 3'b011, 1'b0, 1'b0} : next_state =RESULT;
		{RESULT, 3'b011, 1'b1, 1'b0} : next_state =RESULT;
		{RESULT, 3'b100, 1'b0, 1'b0} : next_state =RESULT;
		{RESULT, 3'b100, 1'b1, 1'b0} : next_state =RESULT;
		{RESULT, 3'b000, 1'b0, 1'b1} : next_state =INITIAL;
		{RESULT, 3'b000, 1'b1, 1'b1} : next_state =INITIAL;
		{RESULT, 3'b001, 1'b0, 1'b1} : next_state =OPERATE;
		{RESULT, 3'b001, 1'b1, 1'b1} : next_state =INITIAL;
		{RESULT, 3'b010, 1'b0, 1'b1} : next_state =OPERATE;
		{RESULT, 3'b010, 1'b1, 1'b1} : next_state =INITIAL;
		{RESULT, 3'b011, 1'b0, 1'b1} : next_state =OPERATE;
		{RESULT, 3'b011, 1'b1, 1'b1} : next_state =INITIAL;
		{RESULT, 3'b100, 1'b0, 1'b1} : next_state =OPERATE;
		{RESULT, 3'b100, 1'b1, 1'b1} : next_state =INITIAL;
		default : next_state =INITIAL;
	endcase      

end  



always@(posedge clk, posedge reset) begin //state transition 
   if(reset) state <= INITIAL;
   else state <= next_state;

end

always@(posedge clk, posedge reset) begin
    if(reset) a <= 0;
    else if(state == RESULT) a <= 1;
    else if(state == NEXT_NUM) a <= 0;
end 

//initial 상태일때 숫자를 입력하면 num reg1에 저장됨 
initial num 상태일때 연산자가 들어왔어 operate로 넘어갔지
두번째 숫자를 입력하면 next num 으로 넘어가겠지 
next num 에서 계산되어 result까지 넘어갔고
이러면 저장공간 4개 첫숫자 연산자 두번째숫자 이고 result 까지 저장되어 저장공간이 4개
여기서 연속계산을 해야하는데 여기서 result에 저장되어있는 num reg1으로 넘긴거임 
여기서 또 연산자가 들어오고 쭈욱 돌려야하니까 
처음들어온값과 result 값을 구분해야하니까(왜?)

우리가



reg[20:0] number_reg1, number_reg2;

always @(posedge clk, posedge reset) begin
   if (reset) number_reg1 <= 0;
	else if((enter==1) && (state ==INITIAL)&&(number)) number_reg1 <= number;
	else if((a==1)&& (enter==1) &&(state == OPERATE)) number_reg1 <= result_reg;
end //여기서 a가 없다고 치면 처음 계산하는거라 치면 첫번째넘버가 num1으로 저장되어있고 지금 오퍼레이트 상태이고 여기서 또 넘버를입력해서 넥스트넘버가되면 num2가 저장되겠지. 이때는 result가 쓰레기값이니까 a가 걸러준다. 결국 a의 용도는 우리가 직접 손으로 첫번째 num을 입력해서 하는 첫번째 계산에서 operate 에서 엔터를 눌렀을때 number_reg1에 아직 계산되지않은 result_Reg 값이 들어가는것을 방지해주기 위함이다.

always @(posedge clk, posedge reset) begin
   if (reset) number_reg2 <= 0;
	else if((enter==1) && (s )&&(number)) number_reg2 <=number;
end

산자
reg [2:0] op_reg;

always @(posedge clk, posedge reset) begin
   if (reset) op_reg <= 0;
	else if( (enter==1) && (state ==INI_NUM)&&(op) ) op_reg <= op;
	else if( (enter==1) && (state ==RESULT)&&(op)) op_reg <= op;
end


always@(*) begin
   if((op_reg== 3'b001)&&(state == NEXT_NUM)) result = number_reg1 + number_reg2;
   else if((op_reg == 3'b010)&&(state == NEXT_NUM)) result = number_reg1 - number_reg2;
   else if((op_reg == 3'b011)&&(state == NEXT_NUM)) result = number_reg1 * number_reg2;
   else if((op_reg == 3'b100) &&(state == NEXT_NUM)) result = number_reg1 / number_reg2;
   else result = 0;
end
과 저장

reg [20:0] result_reg;

always@(posedge clk, posedge reset) begin
	if(reset) result_reg <= 10'd0;
	else if((enter==1)&&(state == NEXT_NUM)&&(eq==1)) result_reg <= result;
end


//output

assign op_out_led = ((state == OPERATE)&&(op == 3'b000))? 4'b0000 :
		         ((state == OPERATE)&&(op == 3'b001))? 4'b0001 :
		         ((state == OPERATE)&&(op == 3'b010))? 4'b0010 :
		         ((state == OPERATE)&&(op == 3'b011))? 4'b0100 :    
		          ((state == OPERATE)&&(op == 3'b100))? 4'b1000 : 4'b1111;



wire [20:0] num;


assign num = (state == INI_NUM)? number_reg1 :
				 (state == NEXT_NUM)? number_reg2 : 
				 (state == RESULT)? result_reg : 0;

assign num_led0 = num  % 10;
assign num_led1 = (num / 10) % 10;
assign num_led2 = (num / 100) % 10;
assign num_led3 = (num / 1000) % 10;
assign num_led4 = (num / 10000) % 10;
assign num_led5 = (num / 100000) % 10;

assign state_check = (state == INITIAL)? 3'b001 :
			(state == INI_NUM)? 3'b010 :
			(state == OPERATE)? 3'b011 :
			(state == NEXT_NUM)? 3'b100 :
			(state == RESULT)? 3'b101 : 3'b111;

endmodule
