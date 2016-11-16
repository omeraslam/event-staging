var DashboardContainer = React.createClass({
    getInitialState: function() {
        return {stats: this.props.stats, registrations: this.props.registrations, eventObj: this.props.eventObj, registration_open: this.props.registration_open, ticket_items: this.props.ticket_items }
    },
    componentWillReceiveProps: function(nextProps) {
        this.setState({eventObj: nextProps.eventObj, registration_open: nextProps.registration_open, ticket_items: nextProps.ticket_items})
    },
    componentDidMount: function() {
        var ctx = document.getElementById("myChart");
        Chart.defaults.global.legend.display = false;


        var a = moment(this.props.eventObj.created_at);
        var b = moment(this.props.eventObj.date_start);
 
        var dateArray = [];
        // If you want an exclusive end date (half-open interval)
        for (var m = moment(a); m.isBefore(b); m.add(1, 'days')) {
         
          dateArray.push(m.format('MM/DD'))
        }

        // If you want an inclusive end date (fully-closed interval)
        for (var m = moment(a); m.diff(b, 'days') <= 0; m.add(1, 'days')) {
        }


        var myChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: dateArray,
                datasets: [{
                    label: '# of Tickets',
                    data: this.props.stats.registration_data == '' ? [] : this.props.stats.registration_data,
                    backgroundColor: [
                        'rgba(33, 175, 191, .05)',
                        'rgba(33, 175, 191, .05)',
                        'rgba(33, 175, 191, .05)',
                        'rgba(33, 175, 191, .05)',
                        'rgba(33, 175, 191, .05)',
                        'rgba(33, 175, 191, .05)'
                    ],
                    borderColor: [
                        'rgba(33, 175, 191, 1)',
                        'rgba(33, 175, 191, 1)',
                        'rgba(33, 175, 191, 1)',
                        'rgba(33, 175, 191, 1)',
                        'rgba(33, 175, 191, 1)',
                        'rgba(33, 175, 191, 1)',
                    ],
                    //borderWidth: 3
                }]
            },
            options: {
                maintainAspectRatio:false,
                responsive:true,
                scales: {
                    yAxes: [{
                        ticks: {
                            suggestedMin: 0,
                            suggestedMax: 10,
                            beginAtZero:true
                        },
                          gridLines: {
                            //color:rgba(0,0,0,.5)
                            zeroLineColor: "rgba(0,0,0,0.0)",
                            color:"rgba(0,0,0,0.0)"

                        } 
                    }], 
                    xAxes: [{
                          ticks: {
                            suggestedMin: 0,
                            suggestedMax: 10,
                            beginAtZero:true
                          },
                          gridLines: {
                            display:false,
                           color:"rgba(0,0,0,0.0)",
                            zeroLineColor: "rgba(0,0,0,0.0)"

                        } 
                    }]
                }
            }
        });



    },
    render:function() {
        if(this.props.stats.total_revenue == 0) {
            DashboardStats = <DashboardStatsFree stats={this.props.stats} />
        } else {
            DashboardStats = <DashboardStatsPaid stats={this.props.stats}/>
        }

        // check if registration really open
        //  - tickets sold
        //  - if the registration close date on those tickets are closed
        //  - if the event has already passed
        //  - draft
        var tickets_closed = true;
        this.state.ticket_items.forEach(function(element) {
            if(( element.stop_date.indexOf('/') > -1 ?  moment(element.stop_date, "MM-DD-YYYY"): moment(element.stop_date) ) > moment.now() && element.is_active == true){
                tickets_closed = false;
            }
        });



        if (this.state.registration_open == true && String(this.state.eventObj.published) == 'true' && (
            ( this.state.eventObj.date_start.indexOf('/') > -1 ?  moment(this.state.eventObj.date_start, "MM-DD-YYYY"): moment(this.state.eventObj.date_start)) && !tickets_closed
            ) ) {
        var registrationStatus  =  <div className="event-activity-meter event-activity-meter-true" ><span> </span> <div className="event-activity-status"><h5>Registration Open</h5> <p>Your event is currently accepting registrations.</p> </div> </div>
        } else {
            var registrationStatus  = <div className="event-activity-meter event-activity-meter-false" ><span> </span> <div className="event-activity-status"><h5>Registration Closed</h5> <p>Your event is currently NOT accepting registrations.  </p> </div> </div>
        }

        return (
            <div className="editor-tool editor-panel-primary" id="editor-tool-dashboard">
               <div className="editor-aside">
                    <section>
                        <h4>Status </h4>
                        <div className={String(this.state.eventObj.published) == 'true' ? "event-activity-meter event-activity-meter-true" : "event-activity-meter event-activity-meter-false"}><span> </span> <div className="event-activity-status"><h5>{String(this.state.eventObj.published) == 'true' ? 'Live' : 'Draft'} </h5> <p> { String(this.state.eventObj.published) == 'true' ?  'Your event website is live and ready to share.': 'Your event website is unpublished and hidden.'}</p> </div> </div>
                        {registrationStatus}
                    </section>

                    <section>
                        <h4>Event URL </h4>
                        <div className="input-group">
                            <input type="text" defaultValue={ "www.eventcreate.com/" + this.props.eventObj.slug}  />
                            <p> <a href={ "https://www.eventcreate.com/" + this.props.eventObj.slug} target="_blank"> Launch event website (new tab)</a> </p>
                        </div>
                    </section>

                    <EventShareSection slug={this.props.eventObj.slug} name={this.props.eventObj.name} />

                </div>



                <div className="editor-panel">
                    <div className="row"> 

                        {DashboardStats}

                    <div className="col-md-12 event-activity-chart">   
                        <canvas id="myChart" width="400" height="400"></canvas> 
                    </div>

                    </div>



                </div>
            




              


        </div>


        )
    }

})