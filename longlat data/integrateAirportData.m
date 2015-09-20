
[row, col] = size(SELECTEDASJunefeatures5minutedelayintervals);
temptable = {};
for i=1: row
    origin = SELECTEDASJunefeatures5minutedelayintervals(i,6);
    
    [row1,col1] = size(airportsCopy);
    
    for j = 1: row1
        display(j)
        if isequal(airportsCopy(j, 1),origin)
            append = airportsCopy(j,4:7);
            temptable= [temptable; append];
            
        end;
        
    end;
end;


SELECTEDASJunefeatures5minutedelayintervalsLONGLAT = [SELECTEDASJunefeatures5minutedelayintervals, temptable];

 
% row =1;
% temptable = {};
% for i=1: row
%     origin = SELECTEDJunefeatures5minutedelayintervals(i,6);
%     
%     [row1,col1] = size(airportsCopy);
%     
%     for j = 1: row1
%         if isequal(airportsCopy(j, 1),origin)
%             append = airportsCopy(j,4:7);
%             temptable= [temptable; append];
%             
%         end;
%         
%     end;
% end;