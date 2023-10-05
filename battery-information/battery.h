//may not need this if the power management chip is axp202
//battery level estimation
//http://www.benzoenergy.com/blog/post/what-is-the-relationship-between-voltage-and-capacity-of-18650-li-ion-battery.html

// function for a quick estimate on 18650 battery based on the voltage
int estimateBatteryPercentage(float voltage) {
    if (voltage >= 4.20) return 100;
    else if (voltage >= 4.06) return 90 + (voltage - 4.06) * (100 - 90) / (4.20 - 4.06);
    else if (voltage >= 3.98) return 80 + (voltage - 3.98) * (90 - 80) / (4.06 - 3.98);
    else if (voltage >= 3.92) return 70 + (voltage - 3.92) * (80 - 70) / (3.98 - 3.92);
    else if (voltage >= 3.87) return 60 + (voltage - 3.87) * (70 - 60) / (3.92 - 3.87);
    else if (voltage >= 3.82) return 50 + (voltage - 3.82) * (60 - 50) / (3.87 - 3.82);
    else if (voltage >= 3.79) return 40 + (voltage - 3.79) * (50 - 40) / (3.82 - 3.79);
    else if (voltage >= 3.77) return 30 + (voltage - 3.77) * (40 - 30) / (3.79 - 3.77);
    else if (voltage >= 3.74) return 20 + (voltage - 3.74) * (30 - 20) / (3.77 - 3.74);
    else if (voltage >= 3.68) return 10 + (voltage - 3.68) * (20 - 10) / (3.74 - 3.68);
    else if (voltage >= 3.45) return  5 + (voltage - 3.45) * (10 -  5) / (3.68 - 3.45);
    else if (voltage >= 3)    return  0 + (voltage - 3)    * ( 5 -  0) / (3.45 - 3);
    else return 0;
}
