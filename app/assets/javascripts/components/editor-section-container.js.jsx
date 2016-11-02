var EditorSectionContainer = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: null, eventObj: this.props.eventObj, ticketObj: this.props.ticketObj, onUpdateEvent:this.props.onUpdateEvent, message: this.props.message, advance_tickets: this.props.advance_tickets }
    },
    getDefaultProps: function() {
        return { items: [], current_selection: null, eventObj: null}
    },

    componentDidMount: function() {
   
    },
    componentWillReceiveProps: function(nextProps) {

        this.setState({current_selection: nextProps.item, eventObj: nextProps.eventObj})
    },

    selectItem: function(item) {
        this.setState({current_selection: item})

    },
    onPanelUpdate: function(_message) {

        this.setState({message: _message})

    },
    refreshNav: function() {

    },
    render: function() {
        return (
           <div>
                <EditorAsideSectionNav handleSelectItem={this.selectItem} />
                 <FormAlert message={this.state.message} />
                <EditorSectionFormContainer current_selection={this.state.current_selection} eventObj={this.state.eventObj} ticketObj={this.state.ticketObj} onUpdateEvent={this.props.onUpdateEvent} onPanelUpdate={this.onPanelUpdate} advance_tickets={this.props.advance_tickets} />
            </div>
        )
   } 
});