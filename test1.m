
Files=dir('*.json');
result = [];
disp("total file:"+length(Files));
for k=1:length(Files)
   
   fname=Files(k).name;
   fid = fopen(fname); 
    raw = fread(fid,inf); 
    str = char(raw'); 
    fclose(fid); 
     disp("file :"+k+"name:"+fname);
    val = jsondecode(str);
    scores = calculateHL(val);
    result = horzcat(result,scores);
end





