%% user.hrl

%% 
%% General-purpose record for storing very basic user information.
%% TODO: Think about adding specs and erldocs. And may be even add those ;)
%%

-record(profile, {  
		firstname,      %% First name
		lastname,       %% Last name
		email,          %% Email. Used as login for saloon-based sites
		roles = [user], %% Role of a user. It's always is good to track who's the boss.
		etc = []        %% Profile extension. Site-dependant property list.
	}).
