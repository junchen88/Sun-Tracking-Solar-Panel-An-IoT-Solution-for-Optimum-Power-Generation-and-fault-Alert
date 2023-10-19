% replace [] with your own credentials for safety reason

% Specify what channel do we read our data from
readChannelID = 2273407;
readAPIKey = 'EVY8X67UC7FHYJNK';

%https://linux-sunxi.org/images/2/20/AXP202_Datasheet_v1.0_en.pdf#:~:text=JOperating%20Temperature%20Range%20-40%20to%20130%20%E2%84%83%20Ts,Storage%20Temperature%20Range%20-40%20to%20150%20%E2%84%83%20T
% -40 to 130 degree celcius

MAXTEMP = 104; % 80% of 130 - since too high is bad for the board

alertAPIKey = [];

% Channel
writeAPIKey = []; %additional channel to store the average data
                                  %as we might need this data in the future for analysis
writeChannelID = 2295027;


% Firstly, we need to obtain the required information for the api call
channelSettingURL = 'https://api.thingspeak.com/channels/2273407.json';
response = webread(channelSettingURL);



data = thingSpeakRead(readChannelID, 'ReadKey', readAPIKey, 'numpoints',1, Location=1, OutputFormat='TimeTable');
boardTemp = data.BoardsTemperaturedegreeCelcius;
%boardTemp = 111; % testing
if boardTemp > MAXTEMP
    alertUrl = "https://api.thingspeak.com/alerts/send";
    options = weboptions("HeaderFields", ["ThingSpeak-Alerts-API-Key", alertAPIKey ]);
    alertSubject = sprintf("Microcontroller board's temperature");
    alertText = "The board's temperature is getting higher than expected ("+boardTemp+" *C),... please check the device!"
    webwrite(alertUrl , "body", alertText, "subject", alertSubject, options);
    %display("sended email")
    thingSpeakWrite(writeChannelID, boardTemp, 'Fields', 3, 'WriteKey', writeAPIKey);

end