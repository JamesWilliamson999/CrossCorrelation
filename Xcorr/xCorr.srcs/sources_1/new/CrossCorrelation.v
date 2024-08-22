`timescale 1ns / 1ps

module CrossCorrelation(
    input clk,
    input clk1Mhz,
    input [15:0] waveRef,
    input [15:0] wave,
    output signed [63:0] xcorr
    );
    reg signed [15:0] bufferRef [19999:-9999];
    reg signed [15:0] buffer [19999:-9999];
    reg signed [15:0] frameRef [19999:-9999];
    reg signed [15:0] frame [19999:-9999];
    
    reg [25:0] frameCounter = 0;
    reg [25:0] subframeCounter = 0;
    reg clkcorr = 0;
    
    reg signed [63:0] product_sum;
    reg signed [15:0] count = -9999;
    
    initial begin
    for ( integer k = -9999; k < 20000; k = k + 1) begin
        bufferRef[k] = 16'b0;
        buffer[k] = 16'b0;
        frameRef[k] = 16'b0;
        frame[k] = 16'b0;
        end
        frame[0] = 16'b0;
        frameRef[0] = 16'b0;
        buffer[0] = 16'b0;
        bufferRef[0] = 16'b0;
    end
    
    always @(negedge clk1Mhz)begin
    
        for (integer i = 9999; i > 0; i = i - 1) begin
           
            bufferRef [i] <= bufferRef [i-1];
            buffer [i] <= buffer [i-1];
            
        end 
        
       buffer [0] <= wave;
       bufferRef [0] <= waveRef;
       
    end
    
    always @(negedge clk)begin
        if (frameCounter == 50000000)begin
            frameCounter <= 1;
            for (integer i = 9999; i >= 0; i = i - 1) begin
           
                frameRef [i] <= bufferRef [i];
                frame [i] <= buffer [i];
            
            end 
        end
        else frameCounter <= frameCounter + 1;
        
        if (subframeCounter == 2500)begin
            subframeCounter <= 0;
            clkcorr <= 1;
        end
        else begin
            subframeCounter <= subframeCounter + 1;
            clkcorr <= 0;
        end
    end

always @(negedge clkcorr)begin
    if (count < 10000) begin
    
        count <= count + 1;
        
        product_sum = 64'b0;
        for (integer j = 0; j < 10000; j = j + 1) begin
            product_sum = product_sum + (frame[j+count] * frameRef[j]);
        end
    end
    else begin
        count <= -9999;
    end
    end
    assign xcorr = product_sum;


endmodule
