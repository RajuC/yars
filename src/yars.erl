-module(yars).
-export([start/0,name/0,male/0,female/0,email/0,zip/0,age/0,phone/0,str/0,str/1,
	num/0,num/1,char/0,char/1,gender/0,birthday/0,birthday/1]).
%%-export([test/0]).

-define(FN,"file/names.txt").
-define(FEMALE_FN,"file/female-fns.txt").
-define(MALE_FN,"file/male-fns.txt").
-define(LN,"file/lastnames.txt").


%%% ==================== Export Functions ===================
start() ->
	ok = application:start(crypto),
	ok = application:start(quickrand),
	ok = application:start(uuid),
	ok = application:start(yars).

%test() ->
%	io:format("~p~n~p~n~p~n~p~n~p~n~p~n~p~n~p~n~p~n~p~n~p~n~p~n~p~n~p~n~p~n~p~n",[name(),
%		male(),female(),email(),zip(),phone(),str(),str(8),num(),num(40),
%		char(),char("sfksdflsdjfljg"),age(),gender(),birthday(),birthday({american,false})]).

%%========
name()->
	get_name(<<"name">>).
%%========
male() ->
	get_name(<<"male">>).
%%========
female() ->
	get_name(<<"female">>).
%%========
email() ->
	First = ran_word(ran_num(3,6),<<"">>),
	Char = to_bin([lists:nth(crypto:rand_uniform(1,length("_.")+1),"_.")]),
	Second = ran_word(ran_num(3,5),<<"">>),
	Domain = ran_word(ran_num(3,5),<<"">>),
	DomainEnd = to_bin(lists:nth(crypto:rand_uniform(1,
		length([".net",".org",".com"])+1),["net","org","com"])),
	<<First/binary,Char/binary,Second/binary,"@",Domain/binary,
		".",DomainEnd/binary>>.
%%========
zip() ->
	ran_num_Len(5).
%%========
phone() ->
	Num0 =ran_num_Len(3),
	Num1=ran_num_Len(3),
	Num2 =ran_num_Len(4),
	<<"(",Num0/binary,") ",Num1/binary,"-",Num2/binary>>.

%%=======
age() ->
	ran_num(1,100).	
%%========
gender() ->
	ran_alpha(["male","female"]).	

%%======
birthday() ->
	birthday({american,true}).

birthday({american,true})->
	{MM,DD,YY} = ran_date(),
	<<MM/binary,"/",DD/binary,"/",YY/binary>>;
birthday({american,false})->
	{MM,DD,YY} = ran_date(),
	<<DD/binary,"/",MM/binary,"/",YY/binary>>.	


%%========
char()->
	ran_alpha("str").
char(Word)->
	ran_alpha(Word).

%%========
str()->
	ran_str(ran_num(3,15),<<"">>).
str(Len)->	
	ran_str(Len,<<"">>).

%%========
num() ->
	ran_num(1,1000).
num(MaxLen) ->
	ran_num(1,MaxLen).	

%% =================Internal Functions ===========================

get_name(Name) ->
	Ln =ran_name(?LN),
%%	io:format("LN::~p~n",[Ln]),
	Fn = 
	case Name of
		<<"name">> ->
			ran_name(?FN);
		<<"male">> ->
			ran_name(?MALE_FN);
		<<"female">> ->
			ran_name(?FEMALE_FN)
	end,
	<< Fn/binary," ",Ln/binary >>.	

%%========
ran_name(File) ->
	{ok,Bin} = file:read_file(File),
	Data = [X||X<-string:tokens(erlang:binary_to_list(Bin),",")],
	to_bin(lists:nth(crypto:rand_uniform(1,length(Data)),Data)).

%%========
ran_word(0,Word) ->
	Word;
ran_word(Count,Word) ->
	Alpha = ran_alpha("word"),
	ran_word(Count-1,<<Word/binary,Alpha/binary>>).
%%========
ran_str(0,Word) ->
	Word;
ran_str(Len,Word) ->
	Alpha = ran_alpha("str"),
	ran_str(Len-1,<<Word/binary,Alpha/binary>>).



%%========
ran_alpha("word") ->
		Data="abcdefghijklmnopqrstuvwxyz",
		to_bin([lists:nth(crypto:rand_uniform(1,length(Data)+1),Data)]);
ran_alpha("str") ->
		Data="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()[]",
		to_bin([lists:nth(crypto:rand_uniform(1,length(Data)+1),Data)]);
ran_alpha(Data) ->
		to_bin([lists:nth(crypto:rand_uniform(1,length(Data)+1),Data)]).				
		
%%========
ran_num(Lo,Hi) ->
	crypto:rand_uniform(Lo,Hi+1).
%%========
ran_num_Len(Len) ->
	to_bin(string:join([to_list(ran_num(1,10))||
		_X<-lists:seq(1,Len)],"")).	
%%========
to_bin(A) ->
	yars_util:to_bin(A).
%%========
to_list(A) ->
	yars_util:to_list(A).
%%========
ran_date() ->
	MM = to_bin(ran_num(1,12)),
	DD = to_bin(ran_num(1,30)),
	YY = to_bin(ran_num(1960,1990)),
	{MM,DD,YY}.	