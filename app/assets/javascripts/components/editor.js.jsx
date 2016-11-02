var Editor = React.createClass({
    getInitialState: function() {
        return { event: this.props.event, ticketObj: this.props.ticketObj, advance_tickets: this.props.advance_tickets,
        attendees_list: this.props.attendees_list, headers: this.props.attendee_headers,
        stats: this.props.stats,
        ticket_items: this.props.ticket_items, current_ticket: '', event_slug: this.props.event_slug,
        order_items: this.props.order_items, order_headers: this.props.order_headers,
        coupon_items: this.props.coupon_items, current_coupon: '', 
        question_items: this.props.question_items, current_question: ''}
    },
    componentDidMount: function() {
    },
    componentWillReceiveProps: function(nextProps) {
        this.setState({
            event: nextProps.event, ticketObj: nextProps.ticketObj, advance_tickets: nextProps.advance_tickets,
        attendees_list: nextProps.attendees_list, headers: nextProps.attendee_headers,
        stats: nextProps.stats,
        ticket_items: nextProps.ticket_items, current_ticket: nextProps.current_ticket, event_slug: nextProps.event_slug,
        order_items: nextProps.order_items, order_headers: nextProps.order_headers,
        coupon_items: nextProps.coupon_items, current_coupon: nextProps.current_coupon, 
        question_items: nextProps.question_items, current_question: nextProps.current_question
        })
    },
    onUpdateEvent: function(item) {
        this.setState({event: item})

    },
    render: function() {
        return (
            <div>
            <EditorSideNav event={this.state.event} />
            <div className="event-editor-section-container"> 
                <div className="event-editor-header text-right">
                   <a href="mailto:support@eventcreate.com">Contact Support</a> <a href="#">My account </a>  <a id="editor-panel-close"><i className="icon icon-arrow-left"> </i></a>
                </div>
                <div className="event-editor-sections"> 
                    <DashboardContainer stats={this.props.stats} eventObj={this.props.event} />
                    <EditorSettings eventObj={this.props.event} ticketObj={this.props.ticketObj} onUpdateEvent={this.onUpdateEvent} advance_tickets={this.props.advance_tickets} />
                    <EditorAttendees attendees_list={this.props.attendees_list} headers={this.props.attendee_headers} />
                    <EditorOrders items={this.props.order_items} headers={this.props.order_headers} />
                    <EditorTicketing items={this.props.ticket_items} current_selection={this.props.current_ticket} event_slug={this.props.event_slug} event_id={this.props.event.id} advance_tickets={this.props.advance_tickets} />
                    <EditorCoupons items={this.props.coupon_items} current_selection={this.props.current_coupon} event_slug={this.props.event_slug} event_id={this.props.event.id}/>
                    <EditorQuestions items={this.props.question_items} current_selection={this.props.current_question} event_slug={this.props.event_slug} event_id={this.props.event.id} /> 
                </div>
            </div>


            <EditorDesign eventObj={this.props.event} />
            </div>
        )
    }
    
});