var EditorSectionContainer = React.createClass({
    getInitialState: function() {
        return { items: this.props.items, current_selection: null, eventObj: this.props.eventObj, ticketObj: this.props.ticketObj, onUpdateEvent:this.props.onUpdateEvent }
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
    onPanelUpdate: function() {

    },
    refreshNav: function() {

    },
    render: function() {
        return (
           <div>
                <EditorAsideSectionNav handleSelectItem={this.selectItem} />
                <EditorSectionFormContainer current_selection={this.state.current_selection} eventObj={this.state.eventObj} ticketObj={this.state.ticketObj} onUpdateEvent={this.props.onUpdateEvent}/>
            </div>
        )
   } 
});