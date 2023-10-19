% Script should be run at the start of the day to get the forecast
% It can obtain the estimates for today and tommorow
% For more accurate result, run this everyday and only obtain the data for today
% as the estimation took the weather into account as well
% Scrape a website to obtain the solar production forecast data so we can use it later
% for our alert system


% Specify what channel do we read our gps from
readChannelID = 2273407;
readAPIKey = 'EVY8X67UC7FHYJNK';


writeAPIKey = []; %additional channel to store the average data
                                  %as we might need this data in the future for analysis
writeChannelID = 2295027;

% Firstly, we need to obtain the required information for the api call
channelSettingURL = 'https://api.thingspeak.com/channels/2273407.json';
response = webread(channelSettingURL);

data = thingSpeakRead(readChannelID, 'ReadKey', readAPIKey, 'numpoints',1, Location=1, OutputFormat='TimeTable');
latitude = string(data.Latitude);
longitude = string(data.Longitude);
elevation = string(data.Altitude);

% for testing when GPS is not working
% latitude = "-31.9789";
% longitude = "115.8181";

declination = "0"; % 0 (horizontal) … 90 (vertical); integer

azimuth = "0"; % -180 … 180 (-180 = north, -90 = east, 0 = south, 90 = west, 180 = north); integer

% TODO add the solar panel power
solarPowerKW = 0.005; %5W solar panel

% Specify the url to get our solar power output prediction
url = 'https://api.forecast.solar/estimate/'+latitude+'/'+longitude+'/'+declination+'/'+azimuth+'/'+solarPowerKW;

% Fetch forecast data
webText = webread(url);

timezone = webText.message.info.timezone;

newDatetime = datetime(webText.message.info.time, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ssXXXXXX', 'Format', 'yyyy-MM-dd HH:mm:ss', 'TimeZone', timezone);
currentDay = newDatetime.Day;

% obtain json key names
keys = fieldnames(webText.result.watts);

% remove x from the name and convert them to datetimes
timestamps = datetime(strrep(keys,'x',''), 'InputFormat', 'yyyy_MM_ddHH_mm_ss', 'Format', 'yyyy-MM-dd HH:mm:ss', 'TimeZone', timezone);

% get the values and transpose to 2x1
values = struct2array(webText.result.watts).';

% create a table
t = table(timestamps, values);
display(t);

% filter the table to only keep current day data
filteredTable = t(day(t.timestamps) == currentDay, :);

% Write the filtered table to another channel specified by the
% 'writeChannelID' variable
thingSpeakWrite(writeChannelID, filteredTable, 'WriteKey', writeAPIKey,'Fields',[1]);
