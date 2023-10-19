% Specify what channel do we read our data from
% replace [] with your own credentials for safety reason
readChannelID = 2273407;
readAPIKey = 'EVY8X67UC7FHYJNK';

alertAPIKey = [];


MINLEVEL = 20;

% Firstly, we need to obtain the required information for the api call
channelSettingURL = 'https://api.thingspeak.com/channels/2273407.json';
response = webread(channelSettingURL);



data = thingSpeakRead(readChannelID, 'ReadKey', readAPIKey, 'numpoints',1, Location=1, OutputFormat='TimeTable');

battLevel = data.BatteryPercentageLevel;
%battLevel = 18; % testing
if battLevel <= MINLEVEL
    alertUrl = "https://api.thingspeak.com/alerts/send";
    options = weboptions("HeaderFields", ["ThingSpeak-Alerts-API-Key", alertAPIKey ]);
    alertSubject = sprintf("Battery Level - Low");
    alertText = "The battery level is getting low: "+ battLevel + "%";
    webwrite(alertUrl , "body", alertText, "subject", alertSubject, options);
end