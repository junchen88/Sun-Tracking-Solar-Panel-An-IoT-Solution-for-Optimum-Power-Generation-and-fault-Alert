% script for converting received time in seconds to hours and minutes
% then write to another channel to store the sunrise and sunset time
% for each day and display the new data.

% Specify what channel do we read our data from
readChannelID = 2273407;
readAPIKey = 'EVY8X67UC7FHYJNK';

% Channel
writeAPIKey = []; %additional channel to store the average data
                                  %as we might need this data in the future for analysis
writeChannelID = 2295027;


% read all data from channel
data = thingSpeakRead(readChannelID, 'ReadKey', readAPIKey, 'numpoints',1, Location=1, OutputFormat='TimeTable');
display(data)

% get sunset and sunrise time
sunriseUnixTime = data.SunriseTime;
sunsetUnixTime = data.SunsetTime;

% Convert seconds to hours
hours = floor(sunriseUnixTime / 3600);

% Get the remaining seconds and convert to minutes
minutes = floor((sunriseUnixTime - (hours * 3600)) / 60);

% Combine hours and minutes into HH.MM format
hh_mm_sunrise = hours + minutes / 100;

% Convert seconds to hours
hours = floor(sunsetUnixTime / 3600);

% Get the remaining seconds and convert to minutes
minutes = floor((sunsetUnixTime - (hours * 3600)) / 60);

% Combine hours and minutes into HH.MM format so we can display it later
hh_mm_sunset = hours + minutes / 100;


thingSpeakWrite(writeChannelID, hh_mm_sunrise, 'Fields', 4, 'WriteKey', writeAPIKey);
pause(15); %pause due to the limitation of ThingSpeak - cannot write to channel within 15 sec
thingSpeakWrite(writeChannelID, hh_mm_sunset, 'Fields', 5, 'WriteKey', writeAPIKey);