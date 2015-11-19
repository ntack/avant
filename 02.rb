class Line
    #a class for a line-of-credit

    #initialize: sets the APR and credit limit based on input, 
    #the balance is by default 0, and the 'day' is set to 0
    def initialize(apr,limit)
        @apr,@limit=apr,limit
        @balance=0.0
        @currentMonth=0

        intStruct = Struct.new(:monthTotal,:currentOut,:firstDay)
            #a struct used to calculate how much interest to deduct
            #from the line at the end of the month
        @interest = intStruct.new
        @interest.monthTotal = 0.0
        @interest.currentOut = 0.0
        @interest.firstDay = 0

        @transactions = Array.new() #store transactions as a list

        @monthLength = 30 #as per problem, replace with some function to get days
        @yearLength = 365.0 
            #note this can make numbers a little weird since months are all length 30

    end

    def updateInterest(totalDays)#totalDays being number of days since line created
        #note that interest is only updated upon a transaction(user function call)
        #(just checking the value in memory would be unsafe)
        daysAtAmount = totalDays - @interest.firstDay
        @interest.monthTotal += (@interest.currentOut * daysAtAmount * @apr/@yearLength)
        @interest.currentOut = @balance
        @interest.firstDay = totalDays
    end

    def updateMonth(totalDays)
        if totalDays-@monthLength*@currentMonth >= @monthLength 
            #adjust the balance if a new period has started, reset monthly interest counter

            monthsElapsed= (totalDays-30*@currentMonth)/30.floor #the number of full months passed
                #since the last transaction
            @interest.monthTotal -= (@interest.currentOut * (totalDays%30) * @apr/365.0)
            @interest.firstDay = monthsElapsed*30
                #recalculate current month interest later

            #"backtrack"- change the month and add the full months' interest to the balance
                #(don't compound interest though)
            @currentMonth+=((totalDays/30).floor)
            @balance+=@interest.monthTotal

        end
        totalDays % @monthLength
    end
    def draw(amount,totalDays)

        
        updateInterest(totalDays) 
            #compute total interest since last transaction
        updateMonth(totalDays)
            #update the current payment period
        

        if(@balance+amount<=@limit or amount<0)
            
            if( amount > 0.0)
                 @transactions << [["draw",amount,totalDays]]
            elsif (amount < 0.0)
                @transactions << [["deposit",amount,totalDays]]
            else #does floating point comparison work in ruby?
                @transactions << [["looked at balance",totalDays]]
            end


            @balance+=amount #update balance
            updateInterest(totalDays)
                #start the new phase of interest rates

        end

    end
    def deposit(amount,totalDays)
        draw(-amount,totalDays)
        
    end
    def checkBalance(totalDays)
        draw(0,totalDays)
            #to record transaction and update balance
        @balance
    end

end

p1 = Line.new(0.35,1000)
p1.draw(500,0)
p1.deposit(200,15)
p1.draw(100,25)
puts p1.checkBalance(30)
p2 = Line.new(0.4,1000)
p2.draw(1000,0)
puts p2.checkBalance(360)