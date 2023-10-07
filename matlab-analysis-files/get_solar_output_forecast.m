% Script should be run at the start of the day to get the forecast
% It can obtain the estimates for today and tommorow
% For more accurate result, run this everyday and only obtain the data for today
% as the estimation took the weather into account as well
% Scrape a website to obtain the solar production forecast data so we can use it later
% for our alert system

% replace [] with your own values due to privacy

% Specify what channel do we read our gps from
readChannelID = [];
readAPIKey = [];


writeAPIKey = []; %additional channel to store the average data
                                  %as we might need this data in the future for analysis
writeChannelID = [];

% Firstly, we need to obtain the required information for the api call
channelSettingURL = 'https://api.thingspeak.com/channels/'+ readChannelID +'.json';
response = webread(channelSettingURL);

data = thingSpeakRead(readChannelID, 'ReadKey', readAPIKey, 'numpoints',1, Location=1, OutputFormat='TimeTable');
latitude = string(data.Latitude);
longitude = string(data.Longitude);
elevation = string(data.Altitude);


declination = string(data.Declination) % 0 (horizontal) … 90 (vertical); integer

azimuth = string(data.Azimuth) % -180 … 180 (-180 = north, -90 = east, 0 = south, 90 = west, 180 = north); integer

% TODO add the solar panel power
solarPowerKW = 0.005; %5W solar panel

% Specify the url to get our solar power output prediction
url = 'https://api.forecast.solar/estimate/'+latitude+'/'+longitude+'/'+declination+'/'+azimuth+'/'+solarPowerKW;

% Fetch forecast data
webText = webread(url);
display(webText)

% Write the temperature data to another channel specified by the
% 'writeChannelID' variable

thingSpeakWrite(writeChannelID, webText.result.watts, 'WriteKey', writeAPIKey);
